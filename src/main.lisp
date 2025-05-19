(defpackage :raylib-voronoi-diagram
  (:use :cl :raylib))

(in-package :raylib-voronoi-diagram)

(defun distance-squared (p1 p2)
  "Calculates the squared distance between two points."
  (let ((dx (- (first p1) (first p2)))
        (dy (- (second p1) (second p2))))
    (+ (* dx dx) (* dy dy))))

(defun find-bounding-box (points)
  "Finds the bounding box of a set of points.
  Returns a list: (min-x min-y max-x max-y)"
  (if (null points)
      (values nil nil nil nil) ; Handle empty list case
      (let ((min-x (first (first points)))
            (min-y (second (first points)))
            (max-x (first (first points)))
            (max-y (second (first points))))
        (dolist (p points)
          (let ((x (first p))
                (y (second p)))
            (when (< x min-x) (setf min-x x))
            (when (< y min-y) (setf min-y y))
            (when (> x max-x) (setf max-x x))
            (when (> y max-y) (setf max-y y))))
        (list min-x min-y max-x max-y))))

(defun create-array (width height initial-value)
  "Creates a 2D array with the given dimensions and initial value."
  (loop repeat width
        collect (loop repeat height
                      collect initial-value)))

(defun calculate-voronoi (points width height)
  "Calculates the Voronoi diagram for a set of points.
  Returns a 2D array representing the diagram."
  (let ((voronoi-diagram (create-array width height -1))) ; Initialize with -1
    (loop for x from 0 below width
          do (loop for y from 0 below height
                   do (let ((closest-site -1)
                            (min-distance-squared most-positive-fixnum) ; Or use a large float
                            (pixel (list x y)))
                        (loop for i from 0 below (length points)
                              do (let ((dist-squared (distance-squared pixel (nth i points))))
                                   (when (< dist-squared min-distance-squared)
                                     (setf min-distance-squared dist-squared)
                                     (setf closest-site i))))
                        (setf (elt (elt voronoi-diagram x) y) closest-site))))
    voronoi-diagram))

(defun color-from-site (site)
  "Generate a color based on the site coordinates."
  (let* ((x (first site))
	 (y (second site))
	 (r (mod x 256))
	 (g (mod y 256))
	 (b (mod (+ x y) 256)))
    (make-rgba r g b 255)))

(defun draw-voronoi-diagram (voronoi-diagram points width height)
  "Draws the Voronoi diagram using Raylib."
  (loop for x from 0 below width
	do (loop for y from 0 below height
		 do (let ((site-index (elt (elt voronoi-diagram x) y)))
		      (when (/= site-index -1)
			(let* ((site (nth site-index points))
			       (color (color-from-site site)))
			  (draw-pixel x y color)))))))

(defun generate-random-points (count max-x max-y)
  "Generate COUNT random points within the given MAX-X and MAX-Y."
  (loop repeat count
	collect (list (random max-x) (random max-y))))

(defun main ()
  "Main function to run the Voronoi diagram generation and display."
  (let* ((width 500)
         (height 500)
	 (points (generate-random-points 10 width height))
         (voronoi-diagram (calculate-voronoi points width height)))
    (with-window (width height "Voronoi Diagram")
      (set-target-fps 60)
      (loop while (not (window-should-close))
	    do (with-drawing
		 (clear-background :white)
		 (draw-voronoi-diagram voronoi-diagram points width height)
		 (loop for point in points 
		       do (draw-circle (first point) (second point) 2.0 :black)))))))
