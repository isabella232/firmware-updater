import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fwupd/fwupd.dart';

extension FwupdDeviceFlagL10n on FwupdDeviceFlag {
  String? localize(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case FwupdDeviceFlag.internal:
        return l10n.fwupdDeviceFlagInternal;
      case FwupdDeviceFlag.updatable:
        return l10n.fwupdDeviceFlagUpdatable;
      case FwupdDeviceFlag.onlyOffline:
        return l10n.fwupdDeviceFlagOnlyOffline;
      case FwupdDeviceFlag.requireAc:
        return l10n.fwupdDeviceFlagRequireAc;
      case FwupdDeviceFlag.locked:
        return l10n.fwupdDeviceFlagLocked;
      case FwupdDeviceFlag.supported:
        return l10n.fwupdDeviceFlagSupported;
      case FwupdDeviceFlag.needsBootloader:
        return l10n.fwupdDeviceFlagNeedsBootloader;
      case FwupdDeviceFlag.registered:
        return l10n.fwupdDeviceFlagRegistered;
      case FwupdDeviceFlag.needsReboot:
        return l10n.fwupdDeviceFlagNeedsReboot;
      case FwupdDeviceFlag.needsShutdown:
        return l10n.fwupdDeviceFlagNeedsShutdown;
      case FwupdDeviceFlag.reported:
        return l10n.fwupdDeviceFlagReported;
      case FwupdDeviceFlag.notified:
        return l10n.fwupdDeviceFlagNotified;
      case FwupdDeviceFlag.useRuntimeVersion:
        return null;
      case FwupdDeviceFlag.installParentFirst:
        return l10n.fwupdDeviceFlagInstallParentFirst;
      case FwupdDeviceFlag.isBootloader:
        return l10n.fwupdDeviceFlagIsBootloader;
      case FwupdDeviceFlag.waitForReplug:
        return l10n.fwupdDeviceFlagWaitForReplug;
      case FwupdDeviceFlag.ignoreValidation:
        return l10n.fwupdDeviceFlagIgnoreValidation;
      case FwupdDeviceFlag.trusted:
        return l10n.fwupdDeviceFlagTrusted;
      case FwupdDeviceFlag.anotherWriteRequired:
        return null;
      case FwupdDeviceFlag.noAutoInstanceIds:
        return null;
      case FwupdDeviceFlag.needsActivation:
        return l10n.fwupdDeviceFlagNeedsActivation;
      case FwupdDeviceFlag.ensureSemver:
        return null;
      case FwupdDeviceFlag.historical:
        return null;
      case FwupdDeviceFlag.onlySupported:
        return null;
      case FwupdDeviceFlag.willDisappear:
        return l10n.fwupdDeviceFlagWillDisappear;
      case FwupdDeviceFlag.canVerify:
        return l10n.fwupdDeviceFlagCanVerify;
      case FwupdDeviceFlag.canVerifyImage:
        return null;
      case FwupdDeviceFlag.dualImage:
        return l10n.fwupdDeviceFlagDualImage;
      case FwupdDeviceFlag.selfRecovery:
        return l10n.fwupdDeviceFlagSelfRecovery;
      case FwupdDeviceFlag.usableDuringUpdate:
        return l10n.fwupdDeviceFlagUsableDuringUpdate;
      case FwupdDeviceFlag.versionCheckRequired:
        return l10n.fwupdDeviceFlagVersionCheckRequired;
      case FwupdDeviceFlag.installAllReleases:
        return l10n.fwupdDeviceFlagInstallAllReleases;
      case FwupdDeviceFlag.mdSetName:
        return null;
      case FwupdDeviceFlag.mdSetNameCategory:
        return null;
      case FwupdDeviceFlag.mdSetVerfmt:
        return null;
      case FwupdDeviceFlag.mdSetIcon:
        return null;
      case FwupdDeviceFlag.addCounterpartGuids:
        return null;
      case FwupdDeviceFlag.noGuidMatching:
        return null;
      case FwupdDeviceFlag.updatableHidden:
        return l10n.fwupdDeviceFlagUpdatable;
      case FwupdDeviceFlag.skipsRestart:
        return null;
      case FwupdDeviceFlag.hasMultipleBranches:
        return l10n.fwupdDeviceFlagHasMultipleBranches;
      case FwupdDeviceFlag.backupBeforeInstall:
        return l10n.fwupdDeviceFlagBackupBeforeInstall;
      case FwupdDeviceFlag.wildcardInstall:
        return l10n.fwupdDeviceFlagWildcardInstall;
      case FwupdDeviceFlag.onlyVersionUpgrade:
        return l10n.fwupdDeviceFlagOnlyVersionUpgrade;
      case FwupdDeviceFlag.unreachable:
        return l10n.fwupdDeviceFlagUnreachable;
      case FwupdDeviceFlag.affectsFde:
        return l10n.fwupdDeviceFlagAffectsFde;
    }
  }
}

extension FwupdExceptionL10n on FwupdException {
  String localize(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (runtimeType) {
      case FwupdInternalException:
        return l10n.fwupdErrorInternal;
      case FwupdVersionNewerException:
        return l10n.fwupdErrorVersionNewer;
      case FwupdVersionSameException:
        return l10n.fwupdErrorVersionSame;
      case FwupdAlreadyPendingException:
        return l10n.fwupdErrorAlreadyPending;
      case FwupdAuthFailedException:
        return l10n.fwupdErrorAuthFailed;
      case FwupdReadException:
        return l10n.fwupdErrorRead;
      case FwupdWriteException:
        return l10n.fwupdErrorWrite;
      case FwupdInvalidFileException:
        return l10n.fwupdErrorInvalidFile;
      case FwupdNotFoundException:
        return l10n.fwupdErrorNotFound;
      case FwupdNothingToDoException:
        return l10n.fwupdErrorNothingToDo;
      case FwupdNotSupportedException:
        return l10n.fwupdErrorNotSupported;
      case FwupdSignatureInvalidException:
        return l10n.fwupdErrorSignatureInvalid;
      case FwupdAcPowerRequiredException:
        return l10n.fwupdErrorAcPowerRequired;
      case FwupdPermissionDeniedException:
        return l10n.fwupdErrorPermissionDenied;
      case FwupdBrokenSystemException:
        return l10n.fwupdErrorBrokenSystem;
      case FwupdBatteryLevelTooLowException:
        return l10n.fwupdErrorBatteryLevelTooLow;
      case FwupdNeedsUserActionException:
        return l10n.fwupdErrorNeedsUserAction;
      // case FwupdAuthExpiredException:
      //   return l10n.fwupdErrorAuthExpired;
      default:
        return l10n.fwupdErrorUnknown;
    }
  }
}
