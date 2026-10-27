import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';

import '../../domain/list_ad_placement.dart';
import '../list_ad_slots.dart';
import '../list_ad_style.dart';

/// 목록의 구분선 자리. 광고 자리([ListAdPlacement])면 구분선 사이에 광고를 넣는다.
/// 광고가 아직 없거나 못 받았으면 평소처럼 구분선만 그린다.
class const ListAdSeparator({
  required final int index,
  required final AppTextStyles styles,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int? slot = ListAdPlacement.slotAt(index);
    final ListAdSlots? slots = slot == null
        ? null
        : ListAdScope.maybeOf(context);
    if (slot == null || slots == null) return const PlainDividerWidget();

    return _ListAdTile(
      key: ValueKey<int>(slot),
      slots: slots,
      slot: slot,
      style: ListAdStyle.from(
        styles,
        Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

class const _ListAdTile({
  required final ListAdSlots slots,
  required final int slot,
  required final ListAdStyle style,
  super.key,
}) extends StatefulWidget {
  @override
  State<_ListAdTile> createState() => _ListAdTileState();
}

class _ListAdTileState() extends State<_ListAdTile> {
  late ListAdSlot _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.slots.acquire(widget.slot, widget.style);
  }

  @override
  void didUpdateWidget(_ListAdTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style || oldWidget.slots != widget.slots) {
      final ListAdSlot previous = _entry;
      final ListAdSlots previousSlots = oldWidget.slots;
      _entry = widget.slots.acquire(widget.slot, widget.style);
      // 옛 광고의 AdWidget 은 이번 프레임에 빠진다. 그 뒤에 놓아야 그려지는
      // 중인 광고를 치우지 않는다.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => previousSlots.release(previous),
      );
    }
  }

  @override
  void dispose() {
    widget.slots.release(_entry);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<NativeAd?>(
    valueListenable: _entry.ad,
    builder: (context, ad, _) {
      if (ad == null) return const PlainDividerWidget();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PlainDividerWidget(),
          SizedBox(
            height: widget.style.height,
            child: AdWidget(key: ObjectKey(ad), ad: ad),
          ),
          const PlainDividerWidget(),
        ],
      );
    },
  );
}
