;;; packages.el --- Rust Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Chris Hoeppner <me@mkaito.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq rust-packages
  '(
    cargo
    company
    racer
    flycheck
    (flycheck-rust :toggle (configuration-layer/package-usedp 'flycheck))
    ggtags
    helm-gtags
    rust-mode
    toml-mode
    ))

(defun rust/post-init-flycheck ()
  (spacemacs/add-flycheck-hook 'rust-mode))

(defun rust/init-flycheck-rust ()
  (use-package flycheck-rust
    :defer t
    :init (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(defun rust/post-init-ggtags ()
  (add-hook 'rust-mode-hook #'spacemacs/ggtags-mode-enable))

(defun rust/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'rust-mode))

(defun rust/init-rust-mode ()
  (use-package rust-mode
    :defer t
    :config
    (progn
      (spacemacs/declare-prefix-for-mode 'rust-mode "mc" "cargo")
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "="  'rust-format-buffer
        "c." 'cargo-process-repeat
        "cc" 'cargo-process-build
        "cd" 'cargo-process-doc
        "ce" 'cargo-process-bench
        "cf" 'cargo-process-current-test
        "ci" 'cargo-process-init
        "cC" 'cargo-process-clean
        "cn" 'cargo-process-new
        "co" 'cargo-process-current-file-tests
        "cx" 'cargo-process-run
        "cs" 'cargo-process-search
        "ct" 'cargo-process-test
        "cu" 'cargo-process-update
        "cX" 'cargo-process-run-example
        "cf" 'spacemacs/rust-cargo-fmt))))

(defun rust/init-toml-mode ()
  (use-package toml-mode
    :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"))

(defun rust/post-init-company ()
  (push 'company-capf company-backends-rust-mode)
  (spacemacs|add-company-hook rust-mode)
  (add-hook 'rust-mode-hook
            (lambda ()
              (setq-local company-tooltip-align-annotations t))))

(defun rust/post-init-smartparens ()
  (with-eval-after-load 'smartparens
    ;; Don't pair lifetime specifiers
    (sp-local-pair 'rust-mode "'" nil :actions nil)))

(defun rust/init-racer ()
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-copy-env "RUST_SRC_PATH"))

  (use-package racer
    :diminish racer-mode
    :defer t
    :init
    (progn
      (spacemacs/add-to-hook 'rust-mode-hook '(racer-mode eldoc-mode))
      (spacemacs/declare-prefix-for-mode 'rust-mode "mg" "goto")
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "gg" 'racer-find-definition))))
