enum RoleType { driver, guard }

RoleType getRoleTypeFromString(String roleString) {
  final roleMap = {
    'LXE': RoleType.driver,
    'BVE': RoleType.guard,
  };

  return roleMap[roleString] ??
      RoleType.driver; // Default to driver if not found
}

extension CustomRoleType on RoleType {
  String roleTypeToString() {
    switch (this) {
      case RoleType.driver:
        return 'LXE';
      case RoleType.guard:
        return 'BVE';
      default:
        return ''; // Handle other cases as needed.
    }
  }
}
