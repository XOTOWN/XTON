# XOTN Denomination System

XOTown 네트워크는 독자적인 단위 명명 체계를 사용합니다.

## 단위 변환표

| Ethereum 단위 | XOTown 단위 | 값 (Woti 기준) | 10의 거듭제곱 |
|--------------|-------------|----------------|---------------|
| Wei          | **Woti**    | 1              | 10⁰           |
| KWei         | **KWoti**   | 1,000          | 10³           |
| MWei         | **MWoti**   | 1,000,000      | 10⁶           |
| GWei         | **GWoti**   | 1,000,000,000  | 10⁹           |
| Szabo        | -           | -              | 10¹²          |
| Finney       | -           | -              | 10¹⁵          |
| Ether        | **XOTN**    | 10¹⁸           | 10¹⁸          |

## 네이밍 규칙

- **Woti**: XOTown의 기본 단위 (Wei → **Wo**town un**ti**)
- **KWoti**: Kilo Woti (1,000 Woti)
- **MWoti**: Mega Woti (1,000,000 Woti)
- **GWoti**: Giga Woti (1,000,000,000 Woti)
- **XOTN**: 메인 코인 단위 (1 XOTN = 10¹⁸ Woti)

## 주요 값

- **총 공급량**: 1,000,000,000,000 XOTN (1조 XOTN)
- **Woti 단위**: 1,000,000,000,000,000,000,000,000,000,000 Woti (10³⁰ Woti)

## 사용 예제

### JavaScript (Console)

```javascript
// XOTown 확장 로드
loadScript("console/xotown.js")

// Woti → XOTN 변환
web3.fromWoti("1000000000000000000", "xotn")
// 결과: "1"

// XOTN → Woti 변환
web3.toWoti("100", "xotn")
// 결과: "100000000000000000000"

// GWoti 단위 사용
web3.fromWoti("5000000000", "gwoti")
// 결과: "5"

// 계정 잔액 확인 (XOTN 단위)
web3.eth.getBalanceXOTN("0x1234...5678")
// 결과: "1000000000000" (1조 XOTN)

// 빠른 확인
xotown.myBalance()
// 출력:
// Address: 0x1234...5678
// Balance: 1000000000000 XOTN
//        : 1000000000000000000000 GWoti
//        : 1000000000000000000000000000000 Woti
```

### Go 코드

```go
package main

import (
    "fmt"
    "math/big"
    "github.com/ethereum/go-ethereum/params"
)

func main() {
    // XOTN 단위 사용
    oneXOTN := new(big.Int).SetUint64(params.XOTN)
    fmt.Println("1 XOTN =", oneXOTN, "Woti")
    // 출력: 1 XOTN = 1000000000000000000 Woti

    // 100 XOTN
    amount := new(big.Int).Mul(big.NewInt(100), oneXOTN)
    fmt.Println("100 XOTN =", amount, "Woti")
    // 출력: 100 XOTN = 100000000000000000000 Woti

    // 1조 XOTN (총 공급량)
    totalSupply := new(big.Int).Mul(
        big.NewInt(1000000000000),
        new(big.Int).SetUint64(params.XOTN),
    )
    fmt.Println("Total Supply =", totalSupply, "Woti")
    // 출력: Total Supply = 1000000000000000000000000000000 Woti

    // GWoti 사용
    gasPrice := new(big.Int).Mul(big.NewInt(20), new(big.Int).SetUint64(params.GWoti))
    fmt.Println("Gas Price = 20 GWoti =", gasPrice, "Woti")
    // 출력: Gas Price = 20 GWoti = 20000000000 Woti
}
```

### Solidity 스마트 계약

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XOTNExample {
    // 1 XOTN = 10^18 Woti
    uint256 constant ONE_XOTN = 1 ether;  // ether는 10^18을 의미

    // 또는 명시적으로
    uint256 constant ONE_XOTN_EXPLICIT = 1e18;

    // GWoti (10^9)
    uint256 constant ONE_GWOTI = 1 gwei;

    function sendXOTN(address recipient) public payable {
        require(msg.value >= ONE_XOTN, "Minimum 1 XOTN required");
        payable(recipient).transfer(msg.value);
    }

    function getBalanceInXOTN(address account) public view returns (uint256) {
        return account.balance / ONE_XOTN;
    }
}
```

## 변환 참조표

| 수량 (XOTN) | 수량 (Woti) | 설명 |
|------------|------------|------|
| 0.000000001 | 1,000,000,000 | 1 GWoti |
| 0.001 | 1,000,000,000,000,000 | 1 MWoti |
| 1 | 1,000,000,000,000,000,000 | 1 XOTN |
| 1,000 | 1,000,000,000,000,000,000,000 | 1천 XOTN |
| 1,000,000 | 1,000,000,000,000,000,000,000,000 | 100만 XOTN |
| 1,000,000,000 | 1,000,000,000,000,000,000,000,000,000 | 10억 XOTN |
| 1,000,000,000,000 | 1,000,000,000,000,000,000,000,000,000,000 | 1조 XOTN (총 공급) |

## 호환성

- **Ethereum 도구 호환**: Wei, GWei, Ether 단위는 여전히 작동합니다
- **MetaMask**: 기본적으로 "ETH" 대신 "XOTN"으로 표시 (네트워크 설정에서)
- **Web3.js**: `web3.fromWei()`와 `web3.toWei()`는 계속 사용 가능
- **XOTown 전용**: `web3.fromWoti()`와 `web3.toWoti()` 권장

## 콘솔 도우미 함수

`console/xotown.js`를 로드하면 다음 기능 사용 가능:

- `xotown.info()` - 네트워크 정보 표시
- `xotown.myBalance()` - 현재 계정 잔액 (여러 단위로)
- `xotown.isXOTown()` - XOTown 네트워크 연결 확인
- `web3.fromWoti(amount, unit)` - Woti → 다른 단위
- `web3.toWoti(amount, unit)` - 다른 단위 → Woti
- `web3.eth.getBalanceXOTN(address)` - 잔액 (XOTN 단위)

## 요약

- ✅ **Ethereum과 호환**: 기존 도구와 라이브러리 사용 가능
- ✅ **독자적 브랜딩**: Woti, GWoti, XOTN 등 독자적 이름
- ✅ **명확한 구분**: XOTown 네트워크 정체성 강화
- ✅ **쉬운 전환**: 기존 Ethereum 개발자도 쉽게 이해

---

**참고**: 코드 레벨에서는 `params.Woti`, `params.GWoti`, `params.XOTN` 상수를 사용하세요.
