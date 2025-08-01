{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  automake,
  libtool,
  pkg-config,
  python3,
  boost,
  libpcap,
  thrift,
  nanomsg,
  gmp,
  judy,
  openssl,
  glib,
  grpc,
  protobuf,
  p4c,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "behavioral-model";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "p4lang";
    repo = "${pname}";
    rev = "${version}";
    hash = "sha256-XXOqRYMQjbfyDJWRg1fKf+Q7n7S8OZX2m/JpuwBi+LI=";
  };

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
    pkg-config
    python3
    makeWrapper
  ];

  buildInputs = [
    boost
    libpcap
    thrift
    nanomsg
    gmp
    judy
    openssl
    glib
    grpc
    protobuf
    p4c
    (python3.withPackages (ps: [ ps.thrift ]))
  ];

  preConfigure = ''
    substituteInPlace tools/get_version.sh \
      --replace-fail "#!/bin/bash" "#!/usr/bin/env bash"
  '';

  configurePhase = ''
    ./autogen.sh
    ./configure
  '';

  installPhase = ''
    make install DESTDIR=$out

    mv $out/usr/local/* $out/

    rmdir $out/usr/local
    rmdir $out/usr
  '';

  meta = {
    description = "The reference P4 software switch";
    homepage = "https://github.com/p4lang/behavioral-model";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ caio86 ];
  };
})
