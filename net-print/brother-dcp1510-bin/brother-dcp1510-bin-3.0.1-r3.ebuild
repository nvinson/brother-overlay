# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm linux-info

BR_PR=${PR/r/}
let BR_PR=( ${BR_PR}-1 )
MY_PN=dcp1510

DESCRIPTION="Brother printer driver for DCP-1510"
HOMEPAGE="http://support.brother.com"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/${MY_PN}cupswrapper-${PV}-${BR_PR}.i386.rpm
	http://www.brother.com/pub/bsc/linux/dlf/${MY_PN}lpr-${PV}-${BR_PR}.i386.rpm"

LICENSE="brother-eula GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

RESTRICT="mirror strip"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S=${WORKDIR}

pkg_setup() {
	CONFIG_CHECK=""
	if use amd64; then
		CONFIG_CHECK="${CONFIG_CHECK} ~IA32_EMULATION"
	fi

	linux-info_pkg_setup
}

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	MODEL="dcp1510"

	mkdir -p "${D}"usr/libexec/cups/filter || die
	mkdir -p "${D}"usr/share/cups/model/Brother || die

	cp -r opt "${D}" || die
	cp -r var "${D}" || die

	( ln -s ../../../../opt/brother/Printers/${MODEL^^}/cupswrapper/brother_lpdwrapper_${MODEL^^} "${D}"usr/libexec/cups/filter/brother_lpdwrapper_${MODEL^^} ) || die

	( ln -s ../../../../../opt/brother/Printers/${MODEL^^}/cupswrapper/brother-${MODEL^^}-cups-en.ppd "${D}"usr/share/cups/model/Brother/brother_${MODEL}_printer_en.ppd ) || die
}
