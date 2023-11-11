## Random User API를 이용한 RxdataSource와 ReactorKit 체험기

<details>
  <summary><h2>구상</h2></summary>
### 첫 화면
<img src="https://github.com/9oHigh/usket.RandomUser/assets/53691249/68502235-eedd-46e4-beeb-b3b80247bd1e" width="300" height="300">

- 최상위의 타이틀 ( 내비게이션 타이틀 )
- 남성 섹션
- 여성 섹션
- 20대 섹션
- 30대 섹션

### 디테일 화면
<img src="https://github.com/9oHigh/usket.RandomUser/assets/53691249/f7e4d031-108c-4631-8587-e08ca004d767" width="300" height="300">

- 각각(여성, 남성...)의 데이터 조회
- 셀 클릭시 같은 동네 사람인 경우, 화면에 표시해주기
</details>

<details>
  <summary><h2><a href="https://randomuser.me/">RandomUser API</a></h2></summary>

- 다음과 같은 데이터를 받을 수 있음
    - JSON
        
        ```json
        {
          "results": [
            {
              "gender": "female",
              "name": {
                "title": "Miss",
                "first": "Jennie",
                "last": "Nichols"
              },
              "location": {
                "street": {
                  "number": 8929,
                  "name": "Valwood Pkwy",
                },
                "city": "Billings",
                "state": "Michigan",
                "country": "United States",
                "postcode": "63104",
                "coordinates": {
                  "latitude": "-69.8246",
                  "longitude": "134.8719"
                },
                "timezone": {
                  "offset": "+9:30",
                  "description": "Adelaide, Darwin"
                }
              },
              "email": "jennie.nichols@example.com",
              "login": {
                "uuid": "7a0eed16-9430-4d68-901f-c0d4c1c3bf00",
                "username": "yellowpeacock117",
                "password": "addison",
                "salt": "sld1yGtd",
                "md5": "ab54ac4c0be9480ae8fa5e9e2a5196a3",
                "sha1": "edcf2ce613cbdea349133c52dc2f3b83168dc51b",
                "sha256": "48df5229235ada28389b91e60a935e4f9b73eb4bdb855ef9258a1751f10bdc5d"
              },
              "dob": {
                "date": "1992-03-08T15:13:16.688Z",
                "age": 30
              },
              "registered": {
                "date": "2007-07-09T05:51:59.390Z",
                "age": 14
              },
              "phone": "(272) 790-0888",
              "cell": "(489) 330-2385",
              "id": {
                "name": "SSN",
                "value": "405-88-3636"
              },
              "picture": {
                "large": "https://randomuser.me/api/portraits/men/75.jpg",
                "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
                "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
              },
              "nat": "US"
            }
          ],
          "info": {
            "seed": "56d27f4a53bd5441",
            "results": 1,
            "page": 1,
            "version": "1.4"
          }
        }
        ```
        
    
- 하나의 데이터가 아니라 원하는 개수 만큼의 데이터를 받아올 수 있음
    ![스크린샷 2023-10-13 오후 9 42 49](https://github.com/9oHigh/usket.RandomUser/assets/53691249/96929b40-2c3d-42b5-bc2d-5e7e3961b967)
    
- 성별을 특정할 수 있음 -  성별을 특정할 시 개수 요청이 불가능
    ![스크린샷 2023-10-13 오후 9 43 30](https://github.com/9oHigh/usket.RandomUser/assets/53691249/488de5f4-75f7-4de5-9419-835f4d517282)

</details>

<details>
  <summary><h2>라이브러리</h2></summary>
  
- [RxDatasource](https://github.com/RxSwiftCommunity/RxDataSources)
    - 섹션별 데이터 처리
- [ReactorKit](https://github.com/ReactorKit/ReactorKit)
    - 아키텍처
- [Alamofire](https://www.google.com/search?q=alamofire+github&oq=alamofire+github&aqs=chrome.0.0i512j0i30j0i8i30l2j69i65l2j69i60.3455j0j7&sourceid=chrome&ie=UTF-8#ip=1)
    - API 사용
    - 이미지 다운로드 및 적용
      
</details>

<details>
  <summary><h2>정리</h2></summary>
  
## Reactors

- 메인화면에 사용될 섹션 모델과 리액터를 정의
    - 메인화면에서 사용될 Action → Mutation → Reduce
        - Action
            - load - 초기 데이터를 가지고 오거나 리프레시시에 재요청을 위한 액션
            - toSectionDetail - 각 섹션의 디테일 화면으로 이동하기 위한 액션
            - removePushed - State에 PushingViewController의 값을 nil로 변경하기 위한 액션
        - Mutation
            - setLoading(Bool) - load 액션이 들어오면 로딩 상태 변경을 위한 Mutation
            - setPeople(PeopleDetail) - load 액션이 들어오면 API를 통해 데이터를 가지고 오고 반환
            - toSectionDetail(People), removePushed
        - Reduce
            - setLoading(Bool) - 로딩 상태 변경
            - setPeople(PeopleDetail) - 상태의 데이터 변경 ( sectionData / 남성, 여성, 20대, 30대 )
            - toSectionDetail(People) - 푸시하려고하는 뷰컨트롤러 변경
            - removePushed
    - 메인화면 셀에서 사용할 리액터 정의
        - 각 셀의 데이터만 가지고 있음
- 디테일 화면에 사용될 섹션 모델과 리액터 정의
    - Action
        - toggle(IndexPath) - 셀을 클릭했을 경우, 같은 곳에 사는 사람들을 보여주기 위한 액션
    - Mutation
        - toggle(IndexPath)
    - Reduce
        - toggle(IndexPath) - 같은 셀을 클릭했을 경우, nil로 상태 변경. 다른 셀일 경우, 해당 IndexPath로 상태 변경.
    - 디테일 화면에 사용될 셀 리액터 정의
        - 각 셀에 적용될 유저의 정보
        - sameAreaPeople - 같은 지역에 사는 사람들을 표시하기위한 멤버
        - isExpanded라는 상태 멤버 - 현재 펼쳐져 있는 상태인지 아닌지 구독하기 위함

## RxDataSource

- MainViewController에서 각 섹션별 데이터를 설정하기 위한 DataSource 사용
    - 섹션
        
        ```swift
        struct MainSectionModel {
            var header: String
            var items: PeopleDetail
        }
        
        extension MainSectionModel: SectionModelType {
            init(original: MainSectionModel, items: PeopleDetail) {
                self = original
                self.items = items
            }
        }
        ```
        
        - 추후에는 같은 구조의 섹션이 아닌 여러개의 UI와 역할을 가진 섹션을 사용해 심화적인 학습이 필요
    - DataSource
        
        ```swift
        let dataSource = RxCollectionViewSectionedReloadDataSource<MainSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell
            cell?.reactor = MainCellReactor(initialState: .init(personInfoDetail: item))
            return cell ?? UICollectionViewCell()
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath
            ) as? SectionHeaderView
            else {
                return UICollectionReusableView()
            }
            
            ...
            
            return header
        })
        ```
        
- DetailViewController에서 각 섹션별 데이터를 설정하기 위한 DataSource 사용
    - 아쉽게도 위와 동일한 섹션모델을 네임만 변경해 사용했고 DataSource도 큰 차이 없음 (구조가 동일..)
    - 추후에는 조금더 복잡한 UI와 구조를 가진 형태로 변경해보기
 
</details>
