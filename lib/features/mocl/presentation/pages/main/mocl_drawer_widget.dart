import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/bloc/get_version_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.onChangeSite});

  final void Function(SiteType) onChangeSite;

  @override
  Widget build(BuildContext context) => SafeArea(
        left: false,
        right: false,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: 220,
                color: Theme.of(context).primaryColor,
                child: Center(
                    child: ClipOval(
                  child: Image.asset('assets/icon.png', width: 80, height: 80),
                )),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: SiteType.values
                      .map(
                        (SiteType siteType) => Column(
                          children: [
                            ListTile(
                              title: Text(siteType.title),
                              titleTextStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              onTap: () {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  onChangeSite(siteType);
                                }
                              },
                              trailing: context.read<SiteTypeBloc>().state ==
                                      siteType
                                  ? Icon(
                                      Icons.check_outlined,
                                      color: Theme.of(context).indicatorColor,
                                    )
                                  : null,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 12,
                              endIndent: 8,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              BlocBuilder<GetVersionCubit, GetVersionState>(
                builder: (BuildContext context, GetVersionState state) {
                  switch (state) {
                    case SuccessGetVersionState():
                      return ListTile(
                        title: Text(state.version, textAlign: TextAlign.center),
                        titleTextStyle: Theme.of(context).textTheme.bodySmall,
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      );
}
