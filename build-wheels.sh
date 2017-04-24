#!/bin/bash
set -e -x

# Install a system package required by our library
yum install -y libtdb-devel

cd /io/

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "$PYBIN" == *"cp26"* ]]; then
        continue
    fi
    PATH=/opt/python/cp27-cp27m/bin/:$PATH "${PYBIN}/python" /io/setup.py bdist_wheel --dist-dir /io/wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in /io/wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done
