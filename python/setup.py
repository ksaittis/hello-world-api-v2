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
        'uvicorn[standard]',
        'pydantic',
        'boto3',
    ],
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
)
