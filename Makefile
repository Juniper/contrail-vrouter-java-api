SRC_VER ?= $(shell cat ./../controller/src/base/version.info)
BUILDNUM ?= $(shell date -u +%m%d%Y)
export BUILDTAG ?= $(SRC_VER)-$(BUILDNUM)

build:
	$(eval BUILDDIR=./../build/vrouter-java-api)
	mkdir -p ${BUILDDIR}
	cp -ar * ${BUILDDIR}
	cp -ar ../controller ../build/
	(cd ${BUILDDIR}; mvn install)

deb: build
	(cd ${BUILDDIR}; debuild --preserve-envvar=BUILDTAG -i -us -uc -b)
	@echo "Wrote: ${BUILDDIR}/../libcontrail-vrouter-java-api_${BUILDTAG}_all.deb"

rpm: build
	$(eval BUILDDIR=$(realpath ./../build/vrouter-java-api))
	cp rpm/libcontrail-vrouter-java-api.spec ${BUILDDIR}
	mkdir -p ${BUILDDIR}/{BUILD,RPMS,SOURCES,SPECS,SRPMS,TOOLS}
	rpmbuild -bb --define "_topdir ${BUILDDIR}" --define "_buildTag $(BUILDNUM)" --define "_srcVer $(SRC_VER)" rpm/libcontrail-vrouter-java-api.spec

clean:
	$(eval BUILDDIR=./../build/vrouter-java-api)
	(cd ${BUILDDIR}; mvn clean)
	rm -rf ${BUILDDIR}/../libcontrail-vrouter-java-api*.*
	rm -rf ${BUILDDIR}/*

