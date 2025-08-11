{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  automake,
  libtool,
  pkg-config,
  python311,
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
    python311
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
    (python311.withPackages (ps: [ ps.thrift ]))
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

    wrapProgram "$out/bin/bm_nanomsg_events" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/${python311.sitePackages}"

    wrapProgram "$out/bin/bm_p4dbg" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/${python311.sitePackages}"

    wrapProgram "$out/bin/simple_switch_CLI" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/${python311.sitePackages}"

    wrapProgram "$out/bin/bm_CLI" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/${python311.sitePackages}"

    wrapProgram "$out/bin/psa_switch_CLI" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$out/${python311.sitePackages}"
  '';

  meta = {
    description = "The reference P4 software switch";
    homepage = "https://github.com/p4lang/behavioral-model";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ caio86 ];
  };
})
