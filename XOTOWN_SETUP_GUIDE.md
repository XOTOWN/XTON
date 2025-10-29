# XOTown Blockchain - Setup & Deployment Guide

## 프로젝트 개요

**XOTN 코인**과 **XOTown 퍼블릭 메인넷**을 위한 go-ethereum 커스터마이징 프로젝트

### 네트워크 사양
- **코인 이름**: XOTN (엑소튼)
- **네트워크**: XOTown Mainnet
- **Chain ID**: 29090
- **합의 알고리즘**: Clique PoA (Proof of Authority)
- **블록 생성 시간**: 3초
- **초기 공급량**: 1,000,000,000,000 XOTN (1조 개, 선채굴)
- **블록 보상**: 0 XOTN (선채굴 완료)

---

## 완료된 작업 (Phase 1-3)

### ✅ Phase 1: 네트워크 기본 설정
1. **params/config.go**
   - `XOTownChainConfig` 추가 (Chain ID: 29090)
   - Clique PoA 설정 (3초 블록타임, Epoch: 30000)
   - 모든 최신 하드포크 활성화 (Shanghai, Cancun, Prague)
   - NetworkNames에 "xotown" 추가

2. **params/protocol_params.go**
   - `XOTownBlockReward = 0` 상수 추가
   - 블록 보상 없음 명시 (선채굴 완료)

3. **params/denomination.go**
   - XOTN 단위 설명 추가
   - 1 XOTN = 10^18 Wei
   - 1조 XOTN = 10^30 Wei

### ✅ Phase 2: Genesis 파일 생성
1. **core/genesis/xotown_mainnet.json**
   - Genesis 블록 템플릿 생성
   - 1조 XOTN 선채굴 설정
   - Clique extraData 필드 준비

2. **tools/generate_extradata.py**
   - Validator 주소로 Clique extraData 생성 스크립트
   - 사용법: `python3 tools/generate_extradata.py <addr1> <addr2> ...`

### ✅ Phase 3: 노드 관리 스크립트
1. **scripts/init_genesis.sh**
   - 5개 노드 디렉토리 생성
   - Genesis 블록 초기화

2. **scripts/start_nodes.sh**
   - 5개 노드 동시 시작
   - Node 1을 Bootnode로 설정
   - 각 노드별 포트 할당 (P2P: 30303-30307, RPC: 8545-8549, WS: 8546-8550)

3. **scripts/stop_nodes.sh**
   - 모든 XOTown 노드 안전하게 종료

4. **scripts/monitor_nodes.sh**
   - 실시간 노드 상태 모니터링
   - 블록 높이, Peer 수, Mining 상태, 잔액 표시

### ✅ Phase 4: 빌드 설정
1. **Makefile**
   - `make xotown` 타겟 추가
   - 빌드 결과물: `build/bin/xotown`

---

## 다음 단계 (실행 필요)

### Step 1: XOTown 바이너리 빌드
```bash
cd /Users/kyungwooncha/Desktop/xoTown-chain/go-ethereum
make xotown
```

빌드 성공 시 `build/bin/xotown` 파일이 생성됩니다.

### Step 2: Validator 계정 생성
5개의 Validator 계정을 생성합니다:

```bash
# 마스터 계정 (1조 XOTN 보유)
mkdir -p ~/xotown-setup/master
build/bin/xotown account new --datadir ~/xotown-setup/master
# 주소와 비밀번호를 안전하게 저장!

# Validator 계정 5개
for i in {1..5}; do
    mkdir -p ~/xotown-setup/validator$i
    build/bin/xotown account new --datadir ~/xotown-setup/validator$i
    # 각 주소와 비밀번호를 저장!
done
```

**중요**: 생성된 모든 주소와 비밀번호를 안전하게 보관하세요!

### Step 3: extraData 생성
생성된 5개 Validator 주소로 extraData를 생성합니다:

```bash
python3 tools/generate_extradata.py \
    0xVALIDATOR1_ADDRESS \
    0xVALIDATOR2_ADDRESS \
    0xVALIDATOR3_ADDRESS \
    0xVALIDATOR4_ADDRESS \
    0xVALIDATOR5_ADDRESS
```

출력된 extraData를 복사합니다.

### Step 4: Genesis 파일 업데이트
`core/genesis/xotown_mainnet.json` 파일을 편집:

```json
{
  "config": { ... },
  "extraData": "0x여기에_생성된_extraData_붙여넣기",
  "alloc": {
    "0x마스터_계정_주소": {
      "balance": "1000000000000000000000000000000"
    }
  },
  ...
}
```

### Step 5: 노드 초기화
```bash
./scripts/init_genesis.sh
```

### Step 6: Keystore 복사
각 노드에 해당하는 Validator keystore 파일을 복사:

```bash
cp ~/xotown-setup/validator1/keystore/* ~/xotown-nodes/node1/keystore/
cp ~/xotown-setup/validator2/keystore/* ~/xotown-nodes/node2/keystore/
cp ~/xotown-setup/validator3/keystore/* ~/xotown-nodes/node3/keystore/
cp ~/xotown-setup/validator4/keystore/* ~/xotown-nodes/node4/keystore/
cp ~/xotown-setup/validator5/keystore/* ~/xotown-nodes/node5/keystore/
```

### Step 7: 비밀번호 파일 생성
```bash
echo "your_password" > ~/xotown-nodes/password.txt
chmod 600 ~/xotown-nodes/password.txt
```

### Step 8: 노드 시작
```bash
./scripts/start_nodes.sh
```

### Step 9: 노드 상태 확인
```bash
./scripts/monitor_nodes.sh
```

또는 개별 노드 콘솔 접속:
```bash
build/bin/xotown attach ~/xotown-nodes/node1/xotown.ipc
```

콘솔에서 확인:
```javascript
// 블록 높이
eth.blockNumber

// Peer 수
net.peerCount

// 마스터 계정 잔액 (1조 XOTN이어야 함)
web3.fromWei(eth.getBalance("0x마스터_계정_주소"), "ether")

// Validator 목록
clique.getSigners()
```

---

## 트러블슈팅

### 빌드 에러
```bash
# Go 버전 확인 (1.21+ 필요)
go version

# 의존성 업데이트
go mod tidy
go mod download
```

### 노드 시작 실패
```bash
# 포트 충돌 확인
netstat -an | grep LISTEN | grep -E "8545|30303"

# 기존 프로세스 정리
./scripts/stop_nodes.sh

# 로그 확인
tail -f ~/xotown-nodes/node1.log
```

### Peer 연결 안 됨
1. 방화벽 확인
2. Bootnode enode 주소 확인
3. Genesis hash 일치 여부 확인

---

## 디렉토리 구조

```
go-ethereum/
├── params/
│   ├── config.go              # XOTownChainConfig
│   ├── protocol_params.go     # 블록 보상 설정
│   └── denomination.go        # XOTN 단위
├── core/
│   └── genesis/
│       └── xotown_mainnet.json  # Genesis 파일
├── scripts/
│   ├── init_genesis.sh        # 초기화
│   ├── start_nodes.sh         # 노드 시작
│   ├── stop_nodes.sh          # 노드 중지
│   └── monitor_nodes.sh       # 모니터링
├── tools/
│   └── generate_extradata.py # extraData 생성
└── build/
    └── bin/
        └── xotown             # 빌드된 바이너리

~/xotown-nodes/
├── node1/                     # Bootnode + Validator
├── node2/                     # Validator
├── node3/                     # Validator
├── node4/                     # Validator
├── node5/                     # Validator
├── password.txt              # 계정 비밀번호
├── node1.log                 # 로그 파일
├── node2.log
├── node3.log
├── node4.log
└── node5.log
```

---

## 포트 매핑

| 노드 | P2P 포트 | RPC 포트 | WS 포트 | 역할 |
|------|---------|---------|---------|------|
| Node 1 | 30303 | 8545 | 8546 | Bootnode + Validator |
| Node 2 | 30304 | 8546 | 8547 | Validator |
| Node 3 | 30305 | 8547 | 8548 | Validator |
| Node 4 | 30306 | 8548 | 8549 | Validator |
| Node 5 | 30307 | 8549 | 8550 | Validator |

---

## 주요 명령어

### 빌드
```bash
make xotown          # XOTown 빌드
make clean           # 클린 빌드
```

### 노드 관리
```bash
./scripts/init_genesis.sh    # Genesis 초기화
./scripts/start_nodes.sh     # 노드 시작
./scripts/stop_nodes.sh      # 노드 중지
./scripts/monitor_nodes.sh   # 실시간 모니터링
```

### 계정 관리
```bash
# 새 계정 생성
build/bin/xotown account new --datadir <path>

# 계정 목록
build/bin/xotown account list --datadir <path>
```

### 콘솔 접속
```bash
# IPC 접속
build/bin/xotown attach ~/xotown-nodes/node1/xotown.ipc

# HTTP 접속
build/bin/xotown attach http://localhost:8545
```

---

## 보안 주의사항

1. **비밀키 보관**: keystore 파일과 비밀번호를 안전하게 보관
2. **방화벽 설정**: 필요한 포트만 개방
3. **RPC 접근 제한**: 프로덕션 환경에서는 localhost로 제한
4. **정기 백업**: chaindata와 keystore 백업

---

## 향후 개발 계획

### Short-term (1-3 months)
- [ ] 외부 노드 참여 가능하도록 Bootnode 공개
- [ ] Block Explorer 구축
- [ ] MetaMask 연결 테스트
- [ ] 테스트넷 운영

### Mid-term (3-6 months)
- [ ] 20+ 외부 validators 확보
- [ ] 모바일 지갑 개발
- [ ] DEX 통합
- [ ] 스마트 계약 생태계 구축

### Long-term (6-12 months)
- [ ] 100+ 노드로 완전 탈중앙화
- [ ] 거래소 상장
- [ ] PoS 전환 검토
- [ ] Cross-chain bridge

---

## 참고 자료

- [Go Ethereum Documentation](https://geth.ethereum.org/)
- [Clique PoA Consensus](https://eips.ethereum.org/EIPS/eip-225)
- [Genesis Block Configuration](https://geth.ethereum.org/docs/fundamentals/private-network)

---

**Happy building your XOTown blockchain! 🚀**
