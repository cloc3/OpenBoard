# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg desktop

DESCRIPTION="open cross-platform interactive whiteBoard application mainly for use in schools"

HOMEPAGE="http://openboard.ch/"
LICENSE="GPL-3"
SLOT="0"

#SRC_URI="https://github.com/OpenBoard-org/OpenBoard/archive/refs/heads/master.zip -> ${P}.zip"
SRC_URI="https://github.com/cloc3/OpenBoard/raw/refs/heads/main/distfiles/${P}.zip"

KEYWORDS="~amd64 ~x86"
PROPERTIES="interactive"

DEPEND="
	app-text/poppler
	dev-libs/quazip
	dev-qt/qtbase
	dev-qt/qtsingleapplication
	dev-qt/linguist-tools
	dev-qt/qtwebengine
"

PDEPEND="
	x11-apps/OpenBoard-Importer
"

RDEPEND="${DEPEND}
"
src_unpack() {
	default
	mv OpenBoard-master ${P}
}

src_prepare() {
	default
	#eapply "${FILESDIR}"/systemQuazip-1.7.1.patch
	eapply "${FILESDIR}"/systemQuazip-1.7.3.patch
}

src_configure() {
	local mycmakeargs=(
	-DCMAKE_CXX_STANDARD=20
	)
}

src_compile() {
	/usr/lib64/qt6/bin/lrelease OpenBoard.pro
	eqmake6 OpenBoard.pro -spec linux-g++
	emake
}

pkg_preinst() {
	xdg_pkg_preinst
}

src_install() {
	default

	einstalldocs
	P_INSTALL_PATH="/usr/lib64/${PN}"
	PRODUCT_DIR="${S}/build/linux/release/product/"
	RESOURCES="${S}/resources"
	EXE="${P_INSTALL_PATH}/${PN}"
	exeinto "${P_INSTALL_PATH}"
	doexe "${PRODUCT_DIR}/${PN}"
	insinto "${P_INSTALL_PATH}"
	doins -r "${PRODUCT_DIR}/library"
	doins -r "${PRODUCT_DIR}/etc"
	doins -r "${PRODUCT_DIR}/i18n"
	doins -r "${RESOURCES}/customizations"
	dosym "${EXE}" "/usr/bin/${PN}"

	doicon "./resources/images/bigOpenBoard.png"
	doicon "./resources/images/OpenBoard.png"
	doicon "./resources/win/OpenBoard.ico"
	doins -r "${RESOURCES}/startupHints"
	# icon from: https://www.file-extensions.org/imgs/app-picture/11685/open-sankore.jpg
	doicon "${FILESDIR}/open-sankore.jpg"
	make_desktop_entry OpenBoard "openboard" "OpenBoard" "Utility"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
