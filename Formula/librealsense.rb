class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.10.1.tar.gz"
  sha256 "e8c09a39ffb0f98e2d034318a2348dd72a9344330badac2025cca3e2291eb2be"
  head "https://github.com/IntelRealSense/librealsense.git"

  bottle do
    cellar :any
    sha256 "9680dbe6e19574545d2e4feaaaa7955646818a6038386e1454034e8fc38d2e68" => :high_sierra
    sha256 "6701c07602cdb0938f28b5fa7d443300ddb21fde9df991a65adcaf9f26f7403d" => :sierra
    sha256 "f2ce5b0e9230dc8ae44b6f4952fc4ad8a7b7999aabc15ebc602427c0b76d7ea9" => :el_capitan
  end

  option "with-examples", "Install examples"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw" if build.with? "examples"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=OFF" if build.without? "examples"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
