enum ContactsViewState {
  loading,
  permissionDenied,
  permissionPermanentlyDenied,
  emptyBook,
  emptySearch,
  error,
  success;

  bool get showsListControls =>
      this == ContactsViewState.success || this == ContactsViewState.emptySearch;
}

enum SortOrder {
  ascending,
  descending;

  SortOrder get toggled => switch (this) {
    SortOrder.ascending => SortOrder.descending,
    SortOrder.descending => SortOrder.ascending,
  };
}
