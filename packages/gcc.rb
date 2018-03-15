class Gcc < Package
  url 'http://mirrors.ustc.edu.cn/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.gz'
  sha256 'fa06e455ca198ddc11ea4ddf2a394cf7cfb66aa7e0ab98cc1184189f1d405870'

  label :compiler

  resource :mpfr do
    url 'http://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.bz2'
    sha256 'a4d97610ba8579d380b384b225187c250ef88cfe1d5e7226b89519374209b86b'
  end

  resource :gmp do
    url 'https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2'
    sha256 '5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2'
  end

  resource :mpc do
    url 'https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz'
    sha256 '6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e'
  end

  resource :isl do
    url 'ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2'
    sha256 '6b8b0fd7f81d0a957beb3679c81bbb34ccc7568d5682844d8924424a0dadcb1b'
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version.to_s.slice(/\d/)}
      --enable-languages=c,c++,fortran
      --disable-multilib
      --with-system-zlib
      --enable-libstdcxx-time=yes
      --enable-stage1-checking
      --enable-checking=release
      --enable-lto
      --with-build-config=bootstrap-debug
      --disable-werror
      --disable-nls
    ]
    install_resource :mpfr, '.'
    mv 'mpfr-4.0.1', 'mpfr'
    install_resource :gmp, '.'
    mv 'gmp-6.1.2', 'gmp'
    install_resource :mpc, '.'
    mv 'mpc-1.1.0', 'mpc'
    install_resource :isl, '.'
    mv 'isl-0.18', 'isl'
    mkdir 'build' do
      run '../configure', *args
      run 'make', 'bootstrap'
      #run 'ulimit -s 32768 && make -k check' unless skip_test?
      run 'make', 'install'
    end
  end
end
