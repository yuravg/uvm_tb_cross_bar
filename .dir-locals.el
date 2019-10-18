;;; Directory Local Variables
;;; For more information see Emacs manual: Per-Directory Local Variables

(
 ;; projectile: registration new project type
 (nil . ((eval . (let ((project-file "uvm_tb/cross_bar_tb.sv"))
                   (if (and (eq 'generic (projectile-project-type))
                            (file-exists-p project-file))
                       (progn
                         (projectile-register-project-type
                          'verilog-cross-bar (list project-file)
                          :compile "make compile"
                          :compilation-dir "sim/"
                          :test "make test_write"
                          :test-dir "sim/")
                         ;; :run "quartus/build.sh") ; TODO: how run script from directory?
                         (projectile-invalidate-cache nil)))))))
 ("uvm_tb" .
  ((verilog-mode . ((yura/verilog-buffer-style . uvm)))
   (verilog-mode . ((eval add-hook
                          'before-save-hook
                          #'yura/verilog-overwrite-identifiers nil :local))))))
