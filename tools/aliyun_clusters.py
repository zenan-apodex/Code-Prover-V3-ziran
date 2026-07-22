"""Company self-hosted E2B-compatible clusters (Aliyun, via e2b-proxy).

Domains + private-CA fullchains lifted from e2b-proxy/examples/aliyun-e2b/
check-image-replacement.py (source of truth: poorman-anyrun/pkg/sandbox/
aliyun_e2b/ca-fullchain-{sg,jb}.pem). VPC-only. Client requirements:
python 3.12 (3.13+ OpenSSL rejects this CA's missing AKI) and e2b==2.23.0
(2.24+ client-side key regex rejects platform keys) — use .venv-aliyun.
"""

from __future__ import annotations

import atexit
import base64
import os
import tempfile

_CA_B64_SG = """\
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVRRENDQXlpZ0F3SUJBZ0lKQUt3ZzNFazJk
SVFRTUEwR0NTcUdTSWIzRFFFQkN3VUFNR3d4Q3pBSkJnTlYKQkFZVEFsVlRNUk13RVFZRFZRUUlE
QXBEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIREExVFlXNGdSbkpoYm1OcApjMk52TVJjd0ZRWURW
UVFLREE1VFpXeG1MVk5wWjI1bFpDQkRRVEVYTUJVR0ExVUVBd3dPVTJWc1ppMVRhV2R1ClpXUWdR
MEV3SGhjTk1qWXdOREF5TURZeE5UUTRXaGNOTWpjd05EQXlNRFl4TlRRNFdqQnNNUXN3Q1FZRFZR
UUcKRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVXTUJRR0ExVUVCd3dOVTJGdUlF
WnlZVzVqYVhOagpiekVYTUJVR0ExVUVDZ3dPVTJWc1ppMVRhV2R1WldRZ1EwRXhGekFWQmdOVkJB
TU1EbE5sYkdZdFUybG5ibVZrCklFTkJNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1J
SUJDZ0tDQVFFQTZHKzF6QWhhUnZlNXIwWjIKOUFvZ2VBZDREM2s2eWlyM0dTKzFCYjYzdThTU3dU
bUZpSEhXWjRDbHBmUzU4QnRVODdsUjVPL053dVQrL2labQpnZldHT0ZhTWY2NVIydkVndEtxSUNE
Y2RQVFpXWEVtWnNWRHpwSFJIM1kvUmE4S2tjQmlYemNLeWFTcHRqWkV4CmZIYlpscER2R0hUSHQ1
aGFsL0FPUmQ0ditJV3RUUnRoQkhTc3B4S244WGtLS1JhVFJPc1lXV2FmMnQ1ZEM3UHQKa01KalZZ
N3VBSklMOVVYV2lLdFc1eFcxRmZuaFkrUlNvTUZ2VmxORUlleVJvZXV4YlRKZ3E5dnhOa3Zqa2pD
WAprZTBaNC9XN2ljcUxIQUFwR3RPUU1ZY3RwYU5LVlNiSDZuaFNJUUZNMHVwSFdZT3dETjZUVDdU
MVNIQjdsWmlFCjlMNzRqd0lEQVFBQm80SGtNSUhoTUIwR0ExVWREZ1FXQkJUTFBYdENHYndGdkY5
UWVnV3hDOTlhbzU5V3JqQ0IKbmdZRFZSMGpCSUdXTUlHVGdCVExQWHRDR2J3RnZGOVFlZ1d4Qzk5
YW81OVdycUZ3cEc0d2JERUxNQWtHQTFVRQpCaE1DVlZNeEV6QVJCZ05WQkFnTUNrTmhiR2xtYjNK
dWFXRXhGakFVQmdOVkJBY01EVk5oYmlCR2NtRnVZMmx6ClkyOHhGekFWQmdOVkJBb01EbE5sYkdZ
dFUybG5ibVZrSUVOQk1SY3dGUVlEVlFRRERBNVRaV3htTFZOcFoyNWwKWkNCRFFZSUpBS3dnM0Vr
MmRJUVFNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdEZ1lEVlIwUEFRSC9CQVFEQWdLawpNQTBHQ1Nx
R1NJYjNEUUVCQ3dVQUE0SUJBUUFrQW1FeHlCdDJCbm54eGtKdFYrcTVVcWI5U0xaR3p1YjFmcEVt
CnZ1UHNQeVhyQ1VYaHRRVzhidVhyZlpiVUNRNTRmT3JHYUZrNW9rRmNoOWVDaTVvVkVtL3NhSngx
cjg1MkJBbkgKRWcwcVRGckFXcnN3ejRNYjIra3N1ME9WSmtyRXZUYlBZVzFmT3pFdGZYT280RStz
anZFQlZBelN0NlVHN282YwpiT0dhVWkvVnI0QnJlbTRGOTU1QjRoa01mRm1HRkFCNmY3QUduNzEx
YzhoTXpJak1ZY0U0T2xnTGsvWlB1Q1kyClpBVkh5bHZYTnFIbWMwdEJpaXI4Q2gyL242ekdjdlVL
aFRCaEFHQ0VOWnBSYTUzYk5yNzRYMkhVRG5rdG51SS8KSTRxeXVWdUsxQVJONTZGRVB2cjNBTTgv
SHZPS3Q5RDRTN2V2RzQ1ci81QkJSWjBzCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"""

_CA_B64_JB = """\
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVRRENDQXlpZ0F3SUJBZ0lKQUpNalBTZGty
MWd1TUEwR0NTcUdTSWIzRFFFQkN3VUFNR3d4Q3pBSkJnTlYKQkFZVEFsVlRNUk13RVFZRFZRUUlE
QXBEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIREExVFlXNGdSbkpoYm1OcApjMk52TVJjd0ZRWURW
UVFLREE1VFpXeG1MVk5wWjI1bFpDQkRRVEVYTUJVR0ExVUVBd3dPVTJWc1ppMVRhV2R1ClpXUWdR
MEV3SGhjTk1qWXdOakl6TURNd05ERTBXaGNOTWpjd05qSXpNRE13TkRFMFdqQnNNUXN3Q1FZRFZR
UUcKRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVXTUJRR0ExVUVCd3dOVTJGdUlF
WnlZVzVqYVhOagpiekVYTUJVR0ExVUVDZ3dPVTJWc1ppMVRhV2R1WldRZ1EwRXhGekFWQmdOVkJB
TU1EbE5sYkdZdFUybG5ibVZrCklFTkJNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1J
SUJDZ0tDQVFFQXhZQXFua1EzdlpFd09mSWEKUVcwU3MvYzlyajlGT1NBUUVPL1Z6aTUyRGZhWFpS
dVY5NmhZSmRqdkVLeFNwZmpIQWVlUkdsaXBkbUtwVTUvNgpPMGM3bC9kUmxYQlJhblM3NXNGcVdR
WkNYMEtnL3ZXMjFsY0QrV0llVlg0U3U4YzBFK3NRL2dOcnMzNnEwYlFhCkJuSVQ1Ti9NUHRJTFFU
SmxHeWlsSVRYRlFEVDE2ZHJXYnovRk0xS3VPaEtHTW1lb0Z3TzBxakhCTWNnMElnZnoKenhFQ250
d0RkOVI3bVNzZ2xwekoxZ1R6YVJzNTZZelNUc2JiWUVCK0gyRUhmR3NKM3d3dUJUak11b1FnTlJz
dAptZEwrcGJJNG42NXpvZXFDYVN6YXdHU3MwZUd1eCtZZ0lOaEQ2WEhIMjNHOStuOHBraWY4andl
Z1g2QXRsQzRFCmNmQVRFUUlEQVFBQm80SGtNSUhoTUIwR0ExVWREZ1FXQkJUMERyVGNyN3g1aFMx
QlZ1elNxU0d2NTFXa0NEQ0IKbmdZRFZSMGpCSUdXTUlHVGdCVDBEclRjcjd4NWhTMUJWdXpTcVNH
djUxV2tDS0Z3cEc0d2JERUxNQWtHQTFVRQpCaE1DVlZNeEV6QVJCZ05WQkFnTUNrTmhiR2xtYjNK
dWFXRXhGakFVQmdOVkJBY01EVk5oYmlCR2NtRnVZMmx6ClkyOHhGekFWQmdOVkJBb01EbE5sYkdZ
dFUybG5ibVZrSUVOQk1SY3dGUVlEVlFRRERBNVRaV3htTFZOcFoyNWwKWkNCRFFZSUpBSk1qUFNk
a3IxZ3VNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdEZ1lEVlIwUEFRSC9CQVFEQWdLawpNQTBHQ1Nx
R1NJYjNEUUVCQ3dVQUE0SUJBUUN1YmhVaFgzQXk2RjBMeWJXWTFvY0dTSC9rS0RETXkxZzZXeWEz
CmF3RUczWFNhb2tNRThCdWpOc2lwQThKRGZ2a2d2NFpBdkc5K3MreE9GSFFsM3o5eHpvbTdXM0kz
VHV5Wm5HTG8KcTE4bHBMM1piVnFyZWxkK3ZDa2JtVk41WkRzbXNoSE1pRXRwZ1pBcm1ZZ3hzc0lG
NUYyTU5IVlZXb25pSlBybApQeUVxWW9IMm5kQmZEWkN2S2QzNzdQNTc3dDVtL0lFYWlxcmlwcGR0
K0djOXZaaG5wbjk1U1hYbGlVSnIwVlVOCjRwRW02c09Nc0NzY1FzbmVlVngwR1h3RW4xUmNXZ2Vq
bzBhN09LVWZOVEpDRnBmazRMTXpwOGJnQ0xyT2xMNWsKdXNkSFpjL1FETzBrTTM4ZGkwdlpVbnkz
S0dtc1hnbjJldWRLZENKa0pmVERraG5PCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"""

CLUSTERS: dict[str, dict[str, str]] = {
    "sg": {"domain": "agent.miro", "ca_b64": _CA_B64_SG},
    "jb": {"domain": "agent.miro.jb", "ca_b64": _CA_B64_JB},
}


def _system_ca_bundle() -> bytes:
    """The default CA store this process would otherwise trust."""
    for candidate in (
        os.environ.get("SSL_CERT_FILE"),
        "/etc/ssl/certs/ca-certificates.crt",  # debian/ubuntu
        "/etc/pki/tls/certs/ca-bundle.crt",    # rhel/alinux
    ):
        if candidate and os.path.isfile(candidate):
            return open(candidate, "rb").read()
    try:
        import certifi
        return open(certifi.where(), "rb").read()
    except ImportError:
        return b""


def configure_env(cluster: str) -> None:
    """Point the e2b SDK at a self-hosted cluster. MUST run before the SDK
    builds an HTTP client. Key: $ALIYUN_E2B_API_KEY_<CLUSTER> wins over
    $ALIYUN_E2B_API_KEY (keys are provisioned per cluster).

    SSL_CERT_FILE is process-wide, so it gets a COMBINED bundle (system CAs
    + the cluster's private CA). A private-CA-only file would break every
    other TLS client in the process — observed as the DPSK gateway failing
    CERTIFICATE_VERIFY_FAILED and every trial dying request_transport_error.
    """
    profile = CLUSTERS[cluster]
    pem = base64.b64decode("".join(profile["ca_b64"].split()))
    key = (
        os.environ.get(f"ALIYUN_E2B_API_KEY_{cluster.upper()}")
        or os.environ.get("ALIYUN_E2B_API_KEY")
    )
    fd, path = tempfile.mkstemp(prefix=f"e2b-ca-{cluster}-", suffix=".pem")
    with os.fdopen(fd, "wb") as f:
        f.write(_system_ca_bundle().rstrip() + b"\n" + pem)
    atexit.register(lambda: os.path.exists(path) and os.unlink(path))
    os.environ["SSL_CERT_FILE"] = path
    os.environ["E2B_DOMAIN"] = profile["domain"]
    if key:
        os.environ["E2B_API_KEY"] = key
