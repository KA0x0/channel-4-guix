(use-modules (gnu) (guix) (guix packages) (srfi srfi-1))
(use-package-modules bootloaders certs fonts package-management shepherd ssh)
(use-service-modules desktop mcron networking ssh virtualization xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "phone")
  (users (cons* (user-account
                  (name "mobile")
                  (comment "Mobile")
                  (group "users")
                  (home-directory "/home/mobile")
                  (supplementary-groups
                    '("audio" "kvm" "netdev" "video" "wheel")))
                %base-user-accounts))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid ""))
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "bcachefs")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "" 'fat32))
             (type "vfat"))
           %base-file-systems))
  (packages
    (append
      (list
        bluez
        dbus
        emacs-with-native-comp-no-x
        emacs-exwm
        pipewire
        usbguard
        xinit
        xrandr)
 %my-base-packagess))
  (services
    (append
      (list (service elogind-service-type)
            (service libvirt-service-type)
            (service login-service-type my-motd)
            (service network-manager-service-type)
            (service openssh-service-type)
            (service wpa-supplicant-service-type)
      %base-services))))

;;; phone-config.scm ends here