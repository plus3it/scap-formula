MAKEFLAGS += --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

OS_PKG_MGR = $(notdir $(or $(shell which apt-get), $(shell which yum)))
ifeq ($(OS_PKG_MGR),apt-get)
OS_PKG_QUERY = apt -qq list $1 2> /dev/null | grep installed > /dev/null
PACKAGES = cmake make expat libopenscap8 libxml2-utils ninja-build python3-jinja2 python3-yaml xsltproc
else ifeq ($OS_PKG_MGR),yum)
OS_PKG_QUERY = rpm -q $1
PACKAGES = cmake make openscap-utils PyYAML python-jinja2
else
$(error Do not know how to install packages without apt-get or yum)
endif

.DEFAULT_GOAL := content

guard/package/%:
	@ $(call OS_PKG_QUERY,$*) || $(MAKE) $(OS_PKG_MGR)/install/$*

apt-get/install/%:
	sudo apt-get update && sudo apt-get -y install $*

yum/install/%:
	sudo yum -y install $*

content: $(foreach package,$(PACKAGES),guard/package/$(package))
	bash -e scripts/build_ssg_content.sh
