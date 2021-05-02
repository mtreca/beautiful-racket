#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display HANDLE-ARGS-EXPR)))
(provide (rename-out [funstacker-module-begin #%module-begin]))

(define (handle-args . args)
  (for/fold ([acc empty])
            ([arg (in-list args)]
             #:unless (void? arg))
    (cond
      [(number? arg) (cons arg acc)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result
         (arg (first acc) (second acc)))
       (cons op-result (drop acc 2))])))
(provide handle-args)

(provide + *)
