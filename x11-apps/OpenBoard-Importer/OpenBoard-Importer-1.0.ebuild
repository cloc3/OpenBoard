# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg desktop

DESCRTPTION="Logiciel stand alone packagé dans l\'executable OpenBoard pour transformer et récupérer les fichiers Open-Sankore"

HOMEPAGE="http://openboard.ch/"
LICENSE="GPL-3"
SLOT="0"

#SRC_URI="https://github.com/OpenBoard-org/OpenBoard-Importer/archive/refs/heads/master.zip"
SRC_URI="https://cloc3.net/distfiles/${P}.zip"

KEYWORDS="~amd64 ~x86"
IUSE=""
PROPERTIES="interactive"

DEPEND="
	app-arch/unzip
	media-libs/freetype
	dev-libs/openssl:0
	sys-libs/zlib
	dev-qt/qtlockedfile
	dev-qt/qtsingleapplication
	media-libs/fdk-aac
	dev-qt/linguist-tools:5
	app-text/xpdf
	dev-libs/quazip
"

RDEPEND="${DEPEND}
"
src_unpack() {
	default
	mv "${PN}-master"  "${P}"
}

src_compile() {
	eqmake5 OpenBoardImporter.pro
	emake
}

src_install() {
	P_INSTALL_PATH="/usr/lib64/OpenBoard"
	exeinto "${P_INSTALL_PATH}"
	doexe "OpenBoardImporter"
	dosym "${P_INSTALL_PATH}/OpenBoardImporter" "/usr/bin/OpenBoardImporter"
	default
}


