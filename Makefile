SRC_VER := $(shell cat ./../controller/src/base/version.info)
BUILDTIME := $(shell date -u +%y%m%d%H%M)
VERSION = $(SRC_VER)-$(BUILDTIME)

all:
	$(eval BUILDDIR=./../build/vrouter-java-api)
	mkdir -p ${BUILDDIR}
	cp -ar * ${BUILDDIR}
	mvn install
	#(cd ${BUILDDIR}; fakeroot debian/rules clean)
	#(cd ${BUILDDIR}; fakeroot debian/rules binary)
	(cd ${BUILDDIR}; debuild -i -us -uc -b)
	@echo "Wrote: ${BUILDDIR}/../libcontrail-vrouter-java-api_all.deb"

clean:
	$(eval BUILDDIR=./../build/vrouter-java-api)
	rm -rf ${BUILDDIR}/../libcontrail-vrouter-java-api*.*
	rm -rf ${BUILDDIR}/*

