
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.4 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (print ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (print ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-engine-state ""
   (not (engine-starts ?))
   (not (repair ?))
   =>
   (assert (engine-starts (yes-or-no-p "Does the engine start (yes/no)? "))))
   
(defrule determine-runs-normally ""
   (engine-starts yes)
   (not (runs-normally ?))
   =>
   (assert (runs-normally (ask-question "Does the engine run normally (yes/no/maybe)? " yes no maybe))))

(defrule determine-rotation-state ""
   (engine-starts no)
   (not (repair ?))   
   =>
   (assert (engine-rotates (yes-or-no-p "Does the engine rotate (yes/no)? "))))
   
(defrule determine-sluggishness ""
   (runs-normally no)
   (not (repair ?))
   =>
   (assert (engine-sluggish (yes-or-no-p "Is the engine sluggish (yes/no)? "))))
   
(defrule determine-misfiring ""
   (runs-normally no)
   (not (repair ?))
   =>
   (assert (engine-misfires (yes-or-no-p "Does the engine misfire (yes/no)? "))))

(defrule determine-knocking ""
   (runs-normally no)
   (not (repair ?))
   =>
   (assert (engine-knocks (yes-or-no-p "Does the engine knock (yes/no)? "))))

(defrule determine-low-output ""
   (runs-normally no)
   (not (repair ?))
   =>
   (assert (engine-output-low
               (yes-or-no-p "Is the output of the engine low (yes/no)? "))))

(defrule determine-gas-level ""
   (engine-starts no)
   (engine-rotates yes)
   (not (repair ?))
   =>
   (assert (tank-has-gas
              (yes-or-no-p "Does the tank have any gas in it (yes/no)? "))))

(defrule determine-battery-state ""
   (engine-rotates no)
   (not (repair ?))
   =>
   (assert (battery-has-charge
              (yes-or-no-p "Is the battery charged (yes/no)? "))))

(defrule determine-point-surface-state ""
   (or (and (engine-starts no)      
            (engine-rotates yes))
       (engine-output-low yes))
   (not (repair ?))
   =>
   (assert (point-surface-state
      (ask-question "What is the surface state of the points (normal/burned/contaminated)? "
                    normal burned contaminated))))

(defrule determine-conductivity-test ""
   (engine-starts no)      
   (engine-rotates no)
   (battery-has-charge yes)
   (not (repair ?))
   =>
   (assert (conductivity-test-positive
              (yes-or-no-p "Is the conductivity test for the ignition coil positive (yes/no)? "))))

;;;*************************************************
;;;* New rules for engine starts and runs normally *
;;;*************************************************

(defrule check-oil-level ""
  (engine-starts yes)
  (runs-normally maybe)
  (not (check ?))
  =>
  (assert (oil-level (yes-or-no-p "Is the oil level normal (yes/no)? "))))

(defrule check-coolant-level ""
  (oil-level yes)
  (not (check ?))
  =>
  (assert (coolant-level (yes-or-no-p "Is the coolant level normal (yes/no)? "))))

(defrule check-transmission-fluid-level ""
  (coolant-level yes)
  (not (check ?))
  =>
  (assert (transmission-fluid-level (yes-or-no-p "Is the transmission fluid level normal (yes/no)? "))))

(defrule check-brake-fluid-level ""
  (transmission-fluid-level yes)
  (not (check ?))
  =>
  (assert (brake-fluid-level (yes-or-no-p "Is the brake fluid level normal (yes/no)? "))))

(defrule check-tire-pressure ""
  (brake-fluid-level yes)
  (not (check ?))
  =>
  (assert (tire-pressure (yes-or-no-p "Is the tire pressure normal (yes/no)? "))))

(defrule check-tire-tread-depth ""
  (tire-pressure yes)
  (not (check ?))
  =>
  (assert (tire-tread-depth (yes-or-no-p "Is the tire tread depth normal (yes/no)? "))))

(defrule check-air-filter-condition ""
  (tire-tread-depth yes)
  (not (check ?))
  =>
  (assert (air-filter-condition (yes-or-no-p "Is the air filter condition normal (yes/no)? "))))

(defrule check-windshield-wiper-fluid-level ""
  (air-filter-condition yes)
  (not (check ?))
  =>
  (assert (windshield-wiper-fluid-level (yes-or-no-p "Is the windshield wiper fluid level normal (yes/no)? "))))

(defrule check-serpentine-belt-condition ""
  (windshield-wiper-fluid-level yes)
  (not (check ?))
  =>
  (assert (serpentine-belt-condition (yes-or-no-p "Is the serpentine belt condition normal (yes/no)? "))))

(defrule check-dashboard-warning-lights ""
  (serpentine-belt-condition yes)
  (not (check ?))
  =>
  (assert (dashboard-warning-lights (yes-or-no-p "Are there any dashboard warning lights on (yes/no)? "))))

;;;****************************************************
;;;* Repair rules for engine starts and runs normally *
;;;****************************************************

(defrule low-oil-level ""
  (oil-level no)
  (not (repair ?))
  =>
  (assert (repair "Add or change the engine oil.")))

(defrule low-coolant-level ""
  (coolant-level no)
  (not (repair ?))
  =>
  (assert (repair "Add or replace the coolant.")))

(defrule low-transmission-fluid-level ""
  (transmission-fluid-level no)
  (not (repair ?))
  =>
  (assert (repair "Add or change the transmission fluid.")))

(defrule low-brake-fluid-level ""
  (brake-fluid-level no)
  (not (repair ?))
  =>
  (assert (repair "Add or change the brake fluid.")))

(defrule abnormal-tire-pressure ""
  (tire-pressure no)
  (not (repair ?))
  =>
  (assert (repair "Adjust tire pressure to the recommended level.")))

(defrule abnormal-tire-tread-depth ""
  (tire-tread-depth no)
  (not (repair ?))
  =>
  (assert (repair "Replace worn tires.")))

(defrule poor-air-filter-condition ""
  (air-filter-condition no)
  (not (repair ?))
  =>
  (assert (repair "Clean or replace the air filter.")))

(defrule low-windshield-wiper-fluid-level ""
  (windshield-wiper-fluid-level no)
  (not (repair ?))
  =>
  (assert (repair "Add or refill the windshield wiper fluid.")))

(defrule poor-serpentine-belt-condition ""
  (serpentine-belt-condition no)
  (not (repair ?))
  =>
  (assert (repair "Inspect and replace the serpentine belt if necessary.")))

(defrule dashboard-warning-lights-on ""
  (dashboard-warning-lights yes)
  (not (repair ?))
  =>
  (assert (repair "Check the owner's manual for the specific warning light and address the issue accordingly.")))

;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule normal-engine-state-conclusions ""
   (runs-normally yes)
   (not (repair ?))
   =>
   (assert (repair "No repair needed.")))

(defrule normal-engine-state-conclusions ""
   (dashboard-warning-lights no)
   (not (repair ?))
   =>
   (assert (repair "No repair needed.")))

(defrule engine-sluggish ""
   (engine-sluggish yes)
   (not (repair ?))
   =>
   (assert (repair "Clean the fuel line."))) 

(defrule engine-misfires ""
   (engine-misfires yes)
   (not (repair ?))
   =>
   (assert (repair "Point gap adjustment.")))     

(defrule engine-knocks ""
   (engine-knocks yes)
   (not (repair ?))
   =>
   (assert (repair "Timing adjustment.")))

(defrule tank-out-of-gas ""
   (tank-has-gas no)
   (not (repair ?))
   =>
   (assert (repair "Add gas.")))

(defrule battery-dead ""
   (battery-has-charge no)
   (not (repair ?))
   =>
   (assert (repair "Charge the battery.")))

(defrule point-surface-state-burned ""
   (point-surface-state burned)
   (not (repair ?))
   =>
   (assert (repair "Replace the points.")))

(defrule point-surface-state-contaminated ""
   (point-surface-state contaminated)
   (not (repair ?))
   =>
   (assert (repair "Clean the points.")))

(defrule conductivity-test-positive-yes ""
   (conductivity-test-positive yes)
   (not (repair ?))
   =>
   (assert (repair "Repair the distributor lead wire.")))

(defrule conductivity-test-positive-no ""
   (conductivity-test-positive no)
   (not (repair ?))
   =>
   (assert (repair "Replace the ignition coil.")))

(defrule no-repairs ""
  (declare (salience -10))
  (not (repair ?))
  =>
  (assert (repair "Take your car to a mechanic.")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (println crlf "The Engine Diagnosis Expert System" crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (println crlf "Suggested Repair:" crlf)
  (println " " ?item crlf))
