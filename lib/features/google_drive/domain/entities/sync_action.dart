enum SyncAction {
  idle, // 아무것도 안함
  promptRestore, // 사용자에게 복원 여부 질문
  autoBackup, // 자동 백업
  initialBackup, // 최초 백업
}
