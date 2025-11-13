# XOTown Node Setup Guide

XOTown 블록체인 노드를 새로운 서버 인스턴스에서 설정하기 위한 완전한 가이드입니다.

## 목차
- [시스템 요구사항](#시스템-요구사항)
- [사전 준비사항](#사전-준비사항)
- [1단계: 저장소 클론](#1단계-저장소-클론)
- [2단계: 의존성 설치](#2단계-의존성-설치)
- [3단계: 노드 빌드](#3단계-노드-빌드)
- [4단계: Genesis 파일 생성](#4단계-genesis-파일-생성)
- [5단계: 노드 초기화](#5단계-노드-초기화)
- [6단계: 노드 실행](#6단계-노드-실행)
- [추가 설정](#추가-설정)
- [문제 해결](#문제-해결)

---

## 시스템 요구사항

### 최소 사양
- CPU: 2+ 코어
- RAM: 4GB
- 스토리지: 100GB+ SSD
- 네트워크: 8 Mbps 이상

### 권장 사양
- CPU: 4+ 코어
- RAM: 8GB+
- 스토리지: 500GB+ SSD (NVMe 권장)
- 네트워크: 25+ Mbps

### 운영체제
- Ubuntu 20.04 LTS 이상
- Debian 10 이상
- CentOS 8 이상
- 기타 Linux 배포판

---

## 사전 준비사항

### 필수 도구
- Git
- Go 1.19 이상 (권장: Go 1.22)
- C 컴파일러 (gcc, build-essential)
- Make

---

## 1단계: 저장소 클론

```bash
# 저장소 클론
git clone <repository-url> /XTON
cd /XTON

# 브랜치 확인
git branch -a
git checkout xotown-v1.13.15
```

---

## 2단계: 의존성 설치

### Ubuntu/Debian 시스템

```bash
# 시스템 패키지 업데이트
sudo apt-get update
sudo apt-get upgrade -y

# 필수 패키지 설치
sudo apt-get install -y build-essential git wget curl

# Go 설치 (최신 버전 권장)
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# 환경 변수 설정
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Go 버전 확인
go version  # go version go1.22.0 linux/amd64 출력 확인
```

### CentOS/RHEL 시스템

```bash
# 시스템 패키지 업데이트
sudo yum update -y

# 필수 패키지 설치
sudo yum groupinstall -y "Development Tools"
sudo yum install -y git wget curl

# Go 설치
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# 환경 변수 설정
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
```

---

## 3단계: 노드 빌드

```bash
# 프로젝트 디렉토리로 이동
cd /XTON

# Geth 빌드
make geth

# 빌드 완료 확인
./build/bin/geth version

# (선택사항) 모든 유틸리티 빌드
# make all
```

빌드가 성공하면 `./build/bin/geth` 실행 파일이 생성됩니다.

---

## 4단계: Genesis 파일 생성

XOTown 네트워크용 Genesis 파일을 생성합니다.

```bash
# Genesis 파일 생성
cat > /XTON/xotown-genesis.json << 'EOF'
{
  "config": {
    "chainId": 29090,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "muirGlacierBlock": 0,
    "berlinBlock": 0,
    "londonBlock": 0,
    "clique": {
      "period": 3,
      "epoch": 30000
    }
  },
  "difficulty": "1",
  "gasLimit": "8000000",
  "extradata": "0x0000000000000000000000000000000000000000000000000000000000000000[SIGNER_ADDRESS]0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "alloc": {}
}
EOF
```

**중요**: `[SIGNER_ADDRESS]` 부분을 실제 시그너 주소로 교체해야 합니다.

---

## 5단계: 노드 초기화

```bash
# 데이터 디렉토리 생성
mkdir -p /data/xotown

# Genesis 파일로 노드 초기화
./build/bin/geth --datadir /data/xotown init /XTON/xotown-genesis.json

# 초기화 성공 메시지 확인
# Successfully wrote genesis state 출력 확인
```

---

## 6단계: 노드 실행

### 기본 노드 실행

```bash
# XOTown 노드 시작
./build/bin/geth \
  --datadir /data/xotown \
  --networkid 29090 \
  --port 30303 \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.api "eth,net,web3,personal,admin,miner,debug,txpool" \
  --http.corsdomain "*" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port 8546 \
  --ws.api "eth,net,web3,personal,admin,miner,debug,txpool" \
  --ws.origins "*" \
  --syncmode "full" \
  --gcmode "archive" \
  --maxpeers 50 \
  console
```

### 백그라운드 실행 (systemd 서비스)

```bash
# systemd 서비스 파일 생성
sudo tee /etc/systemd/system/xotown-node.service > /dev/null << 'EOF'
[Unit]
Description=XOTown Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/XTON
ExecStart=/XTON/build/bin/geth \
  --datadir /data/xotown \
  --networkid 29090 \
  --port 30303 \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.api "eth,net,web3,personal,admin,miner,debug,txpool" \
  --http.corsdomain "*" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port 8546 \
  --ws.api "eth,net,web3,personal,admin,miner,debug,txpool" \
  --ws.origins "*" \
  --syncmode "full" \
  --gcmode "archive" \
  --maxpeers 50
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# 서비스 활성화 및 시작
sudo systemctl daemon-reload
sudo systemctl enable xotown-node
sudo systemctl start xotown-node

# 서비스 상태 확인
sudo systemctl status xotown-node

# 로그 확인
sudo journalctl -u xotown-node -f
```

### Docker 실행 (선택사항)

```bash
# Dockerfile이 이미 프로젝트에 존재하는 경우
docker build -t xotown-node .

# Docker 컨테이너 실행
docker run -d \
  --name xotown-node \
  -v /data/xotown:/root/.ethereum \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -p 30303:30303/udp \
  xotown-node \
  --datadir /root/.ethereum \
  --networkid 29090 \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.api "eth,net,web3,personal,admin,miner,debug,txpool" \
  --http.corsdomain "*" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port 8546 \
  --ws.api "eth,net,web3,personal,admin,miner,debug,txpool" \
  --ws.origins "*"
```

---

## 추가 설정

### 계정 생성

```bash
# 새 계정 생성
./build/bin/geth --datadir /data/xotown account new

# 계정 목록 확인
./build/bin/geth --datadir /data/xotown account list
```

### 부트노드 설정

기존 XOTown 네트워크에 연결하려면 부트노드 정보가 필요합니다:

```bash
./build/bin/geth \
  --datadir /data/xotown \
  --networkid 29090 \
  --bootnodes "enode://[BOOTNODE_PUBKEY]@[BOOTNODE_IP]:30303" \
  [기타 옵션들...]
```

### 마이닝 노드 설정

```bash
# 마이닝 활성화
./build/bin/geth \
  --datadir /data/xotown \
  --networkid 29090 \
  --mine \
  --miner.etherbase [YOUR_ACCOUNT_ADDRESS] \
  --unlock [YOUR_ACCOUNT_ADDRESS] \
  --password /path/to/password.txt \
  [기타 옵션들...]
```

### 방화벽 설정

```bash
# UFW 사용시
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp
sudo ufw allow 8545/tcp  # HTTP RPC (보안 주의!)
sudo ufw allow 8546/tcp  # WebSocket (보안 주의!)

# firewalld 사용시
sudo firewall-cmd --permanent --add-port=30303/tcp
sudo firewall-cmd --permanent --add-port=30303/udp
sudo firewall-cmd --permanent --add-port=8545/tcp
sudo firewall-cmd --permanent --add-port=8546/tcp
sudo firewall-cmd --reload
```

**보안 경고**: RPC 포트(8545, 8546)는 신뢰할 수 있는 IP만 접근할 수 있도록 제한하는 것이 좋습니다.

---

## 문제 해결

### 1. 빌드 오류

**증상**: `make geth` 실패

**해결**:
```bash
# Go 버전 확인 (1.19 이상 필요)
go version

# Go 모듈 캐시 정리
go clean -modcache

# 다시 빌드
make clean
make geth
```

### 2. Genesis 초기화 오류

**증상**: Genesis 초기화 실패

**해결**:
```bash
# 기존 데이터 삭제 후 재초기화
rm -rf /data/xotown/geth
./build/bin/geth --datadir /data/xotown init /XTON/xotown-genesis.json
```

### 3. 피어 연결 안됨

**증상**: 노드가 피어를 찾지 못함

**해결**:
```bash
# 부트노드 정보 확인
# 방화벽 설정 확인
sudo ufw status

# 네트워크 ID 확인 (29090이어야 함)
./build/bin/geth attach /data/xotown/geth.ipc
> admin.nodeInfo.protocols.eth.network
```

### 4. RPC 연결 안됨

**증상**: 외부에서 RPC 접속 불가

**해결**:
```bash
# HTTP 주소가 0.0.0.0으로 설정되었는지 확인
# 방화벽 포트 개방 확인
sudo netstat -tulpn | grep 8545

# 프로세스 확인
ps aux | grep geth
```

### 5. 디스크 공간 부족

**증상**: 동기화 중 디스크 공간 부족

**해결**:
```bash
# 디스크 사용량 확인
df -h

# 오래된 로그 정리
sudo journalctl --vacuum-time=7d

# gcmode 변경 고려 (archive -> full)
```

---

## 네트워크 정보

### XOTown Mainnet
- **Chain ID**: 29090
- **합의 알고리즘**: Clique PoA (Proof of Authority)
- **블록 타임**: 3초
- **Epoch**: 30000 블록
- **네트워크 ID**: 29090
- **심볼**: XOTN

### 포트 정보
- **P2P 포트**: 30303 (TCP/UDP)
- **HTTP RPC**: 8545 (TCP)
- **WebSocket RPC**: 8546 (TCP)
- **IPC**: `/data/xotown/geth.ipc`

---

## 유용한 명령어

### 노드 상태 확인

```bash
# Geth 콘솔 접속
./build/bin/geth attach /data/xotown/geth.ipc

# JavaScript 콘솔에서:
> eth.syncing              # 동기화 상태
> eth.blockNumber          # 현재 블록 높이
> net.peerCount            # 연결된 피어 수
> admin.nodeInfo           # 노드 정보
> admin.peers              # 피어 목록
> eth.accounts             # 계정 목록
> eth.getBalance(eth.accounts[0])  # 잔액 확인
```

### 계정 관리

```bash
# 새 계정 생성
> personal.newAccount("password")

# 계정 잠금 해제
> personal.unlockAccount(eth.accounts[0], "password", 0)
```

### 트랜잭션

```bash
# 트랜잭션 전송
> eth.sendTransaction({from: eth.accounts[0], to: "0x...", value: web3.toWei(1, "ether")})

# 트랜잭션 상태 확인
> eth.getTransaction("0x...")
```

---

## Claude Code로 자동화된 설정

Claude Code를 사용하여 위의 모든 단계를 자동으로 실행할 수 있습니다:

```markdown
Claude에게 다음과 같이 요청하세요:

"XOTOWN_NODE_SETUP.md 파일의 지침에 따라 XOTown 노드를 설정해주세요."

Claude가 다음을 자동으로 수행합니다:
1. 의존성 확인 및 설치
2. 노드 빌드
3. Genesis 파일 생성
4. 노드 초기화
5. 설정 파일 생성
6. 서비스 설정 (선택사항)
```

---

## 참고 자료

- **프로젝트 정보**: README.md
- **Geth 버전**: 1.13.15
- **기반**: Go Ethereum (geth)
- **설정 파일**: params/config.go (Line 117-141)
- **공식 Geth 문서**: https://geth.ethereum.org/docs

---

## 라이선스

이 프로젝트는 GNU General Public License v3.0 라이선스를 따릅니다.

---

**마지막 업데이트**: 2025-11-13
**Geth 버전**: 1.13.15
**XOTown 브랜치**: xotown-v1.13.15
