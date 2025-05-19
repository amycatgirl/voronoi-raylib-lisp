(defsystem raylib-voronoi-diagram
  :description "Display a voronoi diagram using raylib"
  :depends-on (#:cl-raylib)
  :components ((:module "src"
		:components ((:file "main"))))
  :build-operation "program-op"
  :build-pathname "build/visuailization"
  :entry-point "raylib-voronoi-diagram::main")
