SRC_FILES = $(wildcard src/*.d)
D_COMPILER = ldc2
OUT_NAME = elba

all:
	${D_COMPILER} ${SRC_FILES} -of${OUT_NAME}