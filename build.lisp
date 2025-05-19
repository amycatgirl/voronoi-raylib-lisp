(pushnew (uiop:getcwd) ql:*local-project-directories*)
(ql:quickload :raylib-voronoi-diagram)
(asdf:make :raylib-voronoi-diagram)
