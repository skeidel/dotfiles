(defvar myPackages
  '(better-defaults
    elpy
    projectile
    py-autopep8
    material-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)