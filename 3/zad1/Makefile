z1: z1.y z1.l
	bison -d -o z1y.cpp z1.y
	flex -o z1l.cpp z1.l
	g++ -o z1 z1y.cpp z1l.cpp

clean:
	rm z1y.cpp z1y.hpp z1l.c