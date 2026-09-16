# Official Miles amd64 manifest resolved on 2026-09-07. The source checkouts
# are supplied by the shared CPFS mount, not copied into the image.
FROM radixark/miles@sha256:59176c76b445f48d6c73b928b2f6cb983e98d1cc5169b93cb0a07b499e681ab1

# run_dlc.sh requires these exact API versions and no Harbor in the main env.
# The raw Qwen profile does not use Bridge, Energon, FlashQLA or diffusion.
# Remove their incompatible optional pins; retain the actual nixl-cu13 runtime.
RUN python3 -m pip uninstall -y miles harbor megatron-bridge megatron-energon flash-qla nixl moviepy \
    && python3 -m pip install --no-cache-dir \
        e2b==2.34.0 openai==2.6.1 transformers==5.12.1 onnxscript \
        "prettytable>=3.10,<4" "tzdata>=2024.2,<2026" \
        "xattr>=1.3.0,<2" "pyyaml>=6.0.3,<7" \
        tilelang==0.1.11 protobuf==6.33.5 grpcio-tools==1.81.1 \
        nvidia-cudnn-cu13==9.20.0.48 \
    && python3 -m pip check \
    && python3 -c 'import importlib.metadata as m; assert m.version("e2b") == "2.34.0"; assert m.version("openai") == "2.6.1"'

ENV PYTHONUNBUFFERED=1
ENTRYPOINT []
CMD ["/bin/bash"]
