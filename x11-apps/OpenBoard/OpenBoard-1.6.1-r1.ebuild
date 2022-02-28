# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg desktop

DESCRIPTION="open cross-platform interactive whiteBoard application mainly for use in schools"

HOMEPAGE="http://openboard.ch/"
LICENSE="GPL-3"
SLOT="0"

#SRC_URI="https://github.com/OpenBoard-org/OpenBoard/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/cloc3/OpenBoard/distfiles/raw/1.6.1/x11-misc/${PN}/${P}.zip"
#SRC_URI+=" https://github.com/OpenBoard-org/OpenBoard-ThirdParty/archive/refs/heads/master.zip -> OpenBoard-ThirdyParty.zip"

KEYWORDS="~amd64 ~x86"
IUSE=""
#PROPERTIES="interactive"

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
	dev-qt/qtwebkit
"

RDEPEND="${DEPEND}
"
src_prepare() {
	default
	eapply "${FILESDIR}"/c++17_systemQuazip.patch
}

src_configure() {
	local mycmakeargs=(
	-DCMAKE_CXX_STANDARD=17
	)
	cmake_src_configure
}

src_compile() {
	cd "${S}"
	cd resources/i18n
	/usr/lib64/qt5/bin/lrelease OpenBoard_it.ts
	cd -
	eqmake5 OpenBoard.pro -spec linux-g++
	emake
}

pkg_preinst() {
	xdg_pkg_preinst
}

src_install() {
	default
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake DESTDIR="${D}" install
	fi
	einstalldocs

	P_INSTALL_PATH="/usr/lib/${PN}"
	PRODUCT_DIR="${S}/build/linux/release/product/"
	EXE="${P_INSTALL_PATH}/${PN}"
	exeinto "${P_INSTALL_PATH}"
	doexe "${PRODUCT_DIR}/${PN}"
	insinto "${P_INSTALL_PATH}"
	doins -r "${PRODUCT_DIR}/library" "${PRODUCT_DIR}/etc"
	dosym "${D}${EXE}" "/usr/bin/${PN}"

	if [ -f ${S}/ubz-icon/ubz.png ]; then doicon "${S}/ubz-icon/ubz.png";fi 
	ICON_DIR="${S}/resources/images"
	doicon "./resources/images/bigOpenBoard.png"
	doicon "./resources/images/OpenBoard.png"
	doicon "./resources/win/OpenBoard.ico"
	# icon from: https://www.file-extensions.org/imgs/app-picture/11685/open-sankore.jpg
	doicon "${FILESDIR}/open-sankore.jpg"
	make_desktop_entry OpenBoard "openboard" "OpenBoard" "Utility"
	mv "${D}/usr/share/applications/OpenBoard-OpenBoard.desktop" "${D}/usr/share/applications/OpenBoard.desktop"
	echo "MimeType=application/ubz" >> "${D}/usr/share/applications/OpenBoard.desktop"

	dodir "/usr/share/mime/packages/"
	sed '/Document OpenBoard/i\    <icon name="ubz"/>' "${S}/resources/linux/openboard-ubz.xml" > "${D}/usr/share/mime/packages/openboard-ubz.xml"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
