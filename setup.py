from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules=[
    Extension("fanotify", ["fanotify.pyx"])
]

setup(
  name = "fanotify",
  cmdclass = {"build_ext": build_ext},
  py_modules = ['foo'],
  ext_modules = ext_modules
)
