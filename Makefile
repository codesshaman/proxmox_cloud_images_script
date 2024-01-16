name = Create proxmox template

VAR :=				# Cmd arg var
NO_COLOR=\033[0m	# Color Reset
OK=\033[32;01m		# Green Ok
ERROR=\033[31;01m	# Error red
WARN=\033[33;01m	# Warning yellow

all:
	@printf 'Use "make help" for reference\n'

help:
	@echo -e "$(OK)==== Все команды для конфигурации ${name} ===="
	@echo -e "$(WARN)- make				: Launch configuration"
	@echo -e "$(WARN)- make	help			: Get reference"
	@echo -e "$(WARN)- make debian10 (d10)		: Create debian 10 template"
	@echo -e "$(WARN)- make debian11 (d11)		: Create debian 11 template"
	@echo -e "$(WARN)- make debian12 (d12)		: Create debian 12 template"
	@echo -e "$(WARN)- make debian13 (d13)		: Create debian 13 template"
	@echo -e "$(WARN)- make debiansid (dsid)		: Create debian unstable template"
	@echo -e "$(WARN)- make ubuntu2004 (u2004)	: Create ubuntu 20.04 template"
	@echo -e "$(WARN)- make ubuntu2204 (u2204)	: Create ubuntu 22.04 template"
	@echo -e "$(WARN)- make ubuntu2310 (u2310)	: Create ubuntu 23.10 template"
	@echo -e "$(WARN)- make centos7 (c7)		: Create centos 7 template"
	@echo -e "$(WARN)- make centos8 (c8)		: Create centos 8 template"
	@echo -e "$(WARN)- make centos9 (c9)		: Create centos 9 template"
	@echo -e "$(WARN)- make fedora37 (f37)		: Create fedora 37 template"
	@echo -e "$(WARN)- make fedora38 (f38)		: Create fedora 38 template"
	@echo -e "$(WARN)- make rocky8 (r8)		: Create rocky linux 8 template"
	@echo -e "$(WARN)- make rocky9 (r9)		: Create rocky linux 9 template"
	@echo -e "$(WARN)- make clean			: Clean all images"
	@echo -e "$(WARN)- make fclean			: Full clean of all images and archives$(NO_COLOR)"

d10:
	@bash create_template.sh debian10

debian10:
	@bash create_template.sh debian10

d11:
	@bash create_template.sh debian11

debian11:
	@bash create_template.sh debian11

d12:
	@bash create_template.sh debian12

debian12:
	@bash create_template.sh debian12

d13:
	@bash create_template.sh debian13

debian13:
	@bash create_template.sh debian13

dsid:
	@bash create_template.sh debiansid

debiansid:
	@bash create_template.sh debiansid

u2004:
	@bash create_template.sh ubuntu2004

ubuntu2004:
	@bash create_template.sh ubuntu2004

u2204:
	@bash create_template.sh ubuntu2204

ubuntu2204:
	@bash create_template.sh ubuntu2204

u2310:
	@bash create_template.sh ubuntu2310

ubuntu2310:
	@bash create_template.sh ubuntu2310

c7:
	@bash create_template.sh centos7

centos7:
	@bash create_template.sh centos7

c8:
	@bash create_template.sh centos8

centos8:
	@bash create_template.sh centos8

c9:
	@bash create_template.sh centos9

centos9:
	@bash create_template.sh centos9

r8:
	@bash create_template.sh rocky8

rocky8:
	@bash create_template.sh rocky8

r9:
	@bash create_template.sh rocky9

rocky9:
	@bash create_template.sh rocky9

push:
	@bash push.sh

clean:
	@printf "Clean all images...\n"
	@bash clean.sh

fclean:
	@printf "Full clean of all images and archives\n"
	@bash clean.sh full

.PHONY	: all help push clean fclean
