#lang racket/base
(require racket/contract/base)
;;; Science Collection
;;; ode-initval.rkt
;;; Copyright (c) 2004-2011 M. Douglas Williams
;;;
;;; This file is part of the Science Collection.
;;;
;;; The Science Collection is free software: you can redistribute it and/or
;;; modify it under the terms of the GNU Lesser General Public License as
;;; published by the Free Software Foundation, either version 3 of the License
;;; or (at your option) any later version.
;;;
;;; The Science Collection is distributed in the hope that it will be useful,
;;; but WITHOUT WARRANTY; without even the implied warranty of MERCHANTABILITY
;;; or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
;;; License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public License
;;; along with the Science Collection.  If not, see
;;; <http://www.gnu.org/licenses/>.
;;;
;;; -------------------------------------------------------------------
;;;
;;; This module provides an ordinary differential equation solver
;;; capability for PLT Scheme.  
;;;
;;; Version  Date      Description
;;; 2.0.0    11/19/07  Added header.  (Doug Williams)
;;; 2.0.1    01/29/08  Added contracts.  (Doug Williams)
;;; 2.1.0    06/07/08  Changed the components to be separate modules
;;;                    with this one providing the contracts.  Made
;;;                    changes required for V4.0.  (Doug Williams)
;;; 2.1.1    06/14/08  Add unchecked procedures.  (Doug Williams)
;;; 4.0.0    08/16/11  Changed the header and restructured the code. (MDW)

(require "ode-initval/system.rkt"
         "ode-initval/step.rkt"
         "ode-initval/control.rkt"
         "ode-initval/standard-control.rkt"
         "ode-initval/evolve.rkt")

(provide
 (rename-out (ode-system-function-eval unchecked-ode-system-function-eval)
             (ode-system-jacobian-eval unchecked-ode-system-jacobian-eval)
             (ode-step-apply unchecked-ode-step-apply)
             (ode-step-reset unchecked-ode-step-reset)
             (ode-evolve-apply unchecked-ode-evolve-apply)
             (ode-evolve-reset unchecked-ode-evolve-reset)))

;;; Contracts

(provide
 ode-system?
 make-ode-system
 ode-system-function
 ode-system-jacobian
 ode-system-dimension
 ode-system-params
 ode-system-function-eval
 ode-system-jacobian-eval
 ode-step-type?
 make-ode-step-type
 ode-step-type-name
 ode-step-type-can-use-dydt-in?
 ode-step-type-gives-exact-dydt-out?
 ode-step-type-make
 ode-step-type-apply
 ode-step-type-reset
 ode-step-type-order
 ode-step?
 make-ode-step
 ode-step-step-type
 ode-step-dimension
 ode-step-state
 ode-step-name
 ode-step-order
 ode-step-apply
 ode-step-reset
 standard-control-state?
 make-standard-control-state
 standard-control-state-eps-abs
 standard-control-state-eps-rel
 standard-control-state-a_y
 standard-control-state-a_dydt)

(provide
 make-ode-control
 ode-control-init
 ode-control-name
 ode-control-h-adjust
 make-ode-evolve
 ode-evolve-count
 ode-evolve-failed-steps
 standard-control-new
 control-y-new
 control-yp-new
 ode-evolve-reset
 ode-evolve-apply
 )

;;; Routines
;;; Include the predefined ODE solvers.

(require "ode-initval/rk2.rkt")
(require "ode-initval/rk4.rkt")
(require "ode-initval/rkf45.rkt")

(provide 
 rk2-ode-type
 rk4-ode-type
 rkf45-ode-type)
