SRC_VER := $(shell cat ./../controller/src/base/version.info)
BUILDTIME := $(shell date -u +%m%d%Y)

ifdef SRC_VER
BUILDTAG = $(SRC_VER)-$(BUILDTIME)
else
BUILDTAG = $(BUILDTIME)
endif


all:
	$(eval BUILDDIR=./../build/vrouter-java-api)
	mkdir -p ${BUILDDIR}
	cp -ar * ${BUILDDIR}
	cp -ar ../controller ../build/
	(cd ${BUILDDIR}; mvn install)
	#(cd ${BUILDDIR}; fakeroot debian/rules clean)
	#(cd ${BUILDDIR}; fakeroot debian/rules binary)
	(cd ${BUILDDIR}; debuild -i -us -uc -b)
	@echo "Wrote: ${BUILDDIR}/../libcontrail-vrouter-java-api_${BUILDTAG}_all.deb"

clean:
	$(eval BUILDDIR=./../build/vrouter-java-api)
	(cd ${BUILDDIR}; mvn clean)
	rm -rf ${BUILDDIR}/../libcontrail-vrouter-java-api*.*
	rm -rf ${BUILDDIR}/*

