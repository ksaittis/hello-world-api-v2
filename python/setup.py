from setuptools import find_namespace_packages, setup

setup(
    name='hello-api',
    version='0.1.0',
    description='Simple Hello World API with FastAPI',
    author="ksaittis",
    python_requires=">=3.8, <4.0",
    packages=find_namespace_packages('src/', include=['app.*']),
    package_dir={'': 'src'},
    install_requires=[
        'fastapi',
        'uvicorn[standard]>=0.20.0',
        'pydantic>=1.10.6',
        'boto3>=1.26.87',
    ],
    extras_require={
        'tests': ['pytest>=3.7.0', 'freezegun>=1.2.2', 'moto[dynamodb]>=4.1.4'],
    },
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
)
