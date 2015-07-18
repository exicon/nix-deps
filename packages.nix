with import <nixpkgs> {};
{
  zerotierone = stdenv.mkDerivation rec {
    version = "1.0.2";
    name = "zerotierone";

    src = fetchurl {
      url = "https://github.com/zerotier/ZeroTierOne/archive/${version}.tar.gz";
      sha256 = "002ay4f6l9h79j1708klwjvinsv6asv24a0hql85jq27587sv6mq";
    };

    preConfigure = ''
      substituteInPlace ./make-linux.mk \
          --replace 'CC=$(shell which clang gcc cc 2>/dev/null | head -n 1)' "CC=${gcc}/bin/gcc";
      substituteInPlace ./make-linux.mk \
          --replace 'CXX=$(shell which clang++ g++ c++ 2>/dev/null | head -n 1)' "CC=${gcc}/bin/g++";
    '';

    buildInputs = [ openssl lzo zlib gcc ];

    installPhase = ''
      installBin zerotier-one
    '';

    meta = {
      description = "Create flat virtual Ethernet networks of almost unlimited size";
      homepage = https://www.zerotier.com;
      license = stdenv.lib.licenses.gpl3;
      maintainers = [ stdenv.lib.maintainers.sjmackenzie ];
      platforms = stdenv.lib.platforms.all;
    };
  };

  boot = stdenv.mkDerivation rec {
    version = "2.0.0";
    name = "boot-${version}";

    src = fetchurl {
      url = "https://github.com/boot-clj/boot/releases/download/${version}/boot.sh";
      sha256 = "12c24aqvwq8kj6iiac18rp0n8vlzacl7dd95m983yz24w885chc0";
    };

    inherit jdk;

    builder = ./boot_builder.sh;

    buildInputs = [ makeWrapper ];

    propagatedBuildInputs = [ jdk ];

    meta = {
      description = "Build tooling for Clojure";
      homepage = http://boot-clj.com/;
      license = stdenv.lib.licenses.epl10;
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
      maintainers = [ stdenv.lib.maintainers.sjmackenzie ];
    };
  };
}
