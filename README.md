# HelpHand

> 김하진, 박근영

> Flutter, Firebase

|로그인|홈|피드|채팅|프로필|
|--|--|--|--|--|
|<img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/cdd08dfd-902b-47fc-8704-61341c06dec7" width="200" height="400">|<img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/210a157b-22fe-4181-b658-34b10a1cf8b9" width="200" height="400">|<img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/54ac7ab0-c337-4af6-9481-6c666ecca2cd" width="200" height="400">|<img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/26c77595-6a48-440d-a239-362b598ddecf" width = "200" height = "400">|<img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/2538ccbe-4669-4fa0-ae16-2fa89ddf2f7b" width = "200" height = "400">|

## 로그인
> 회원가입을 통한 로그인이 가능합니다.

- ### 회원가입

  <img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/8e292b40-7805-464c-9432-3ebe34fa49e9" width="200" height="400">

   - 닉네임, 이메일주소, 비밀번호, 한줄소개를 입력할 수 있음
   - 이메일주소는 이메일 형식에 맞게, 비밀번호는 6자리 이상으로 입력하면 회원가입하기 버튼을 눌러 아이디와 비밀번호를 데이터베이스에 저장할 수 있음

- ### 로그인 

  <img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/cdd08dfd-902b-47fc-8704-61341c06dec7" width="200" height="400">

  - 가입했던 계정 아이디와 비밀번호를 올바르게 입력하고 로그인 버튼을 누르면 로그인 할 수 있음
  - 로그인에 성공시 홈화면으로 넘어감


## Tab1 : 홈
> 내가 준 도움, 내가 받은 도움 수에 따른 캐릭터를 볼 수 있습니다.
> 진행중인 도움, 요청중인 도움의 정보를 간단하게 확인할 수 있습니다.
> 내 주변에서 요청한 도움들을 지도에서 확인할 수 있습니다.

- ### 캐릭터

  <img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/38ef6af7-d84d-43cc-90c8-ac3462108534" width="500" height="400">

   - 도움을 주고받으면 캐릭터가 성장함
   - 홈 화면에서 캐릭터를 확인할 수 있음

- ### 도움 정보

  <img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/3ee341ba-6db4-467b-a932-c6396fe12ccc" width="500" height="400">

  - 진행 중인 도움에선 내가 도움을 주고 있는 요청의 이름을 확인할 수 있음
  - 요청 중인 도움에선 내가 도움을 받고 있는 요청의 이름을 확인할 수 있음

- ### 주변 요청 
  
  <img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/5b95cff6-872f-41af-ad6c-55a3b31ef972" width="500" height="400">

  - 위치 정보를 통해 현재 내 위치의 주변에서 요청한 도움들을 지도에서 확인할 수 있음

## Tab2 : 피드
> 피드 Tab에선 유저들이 올린 도움 요청들을 모두 확인할 수 있습니다.
> 하단 bar의 가운데 + 버튼을 눌러 도움 요청을 등록할 수 있습니다.
> 도움 요청의 제목, 설명, 올린 사람의 이름, 올린 날짜, 올린 위치와의 거리등을 확인할 수 있습니다.
> 도와주기 버튼을 눌러 채팅을 시작하며 도움을 줄 수 있습니다.

- ### 도움 요청
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/25442e67-5839-479e-8870-4af83d45d6d4" width = "200" height = "400" >
  
  - 도움 요청의 한줄 소개와 내용을 입력하여 도움 요청을 등록할 수 있음

- ### 도와주기
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/a2f2ea7e-c498-401b-9844-d3295d22e2f3" width = "500" height = "400" >
  
  - 도와주고 있는 사람이 없는 타인의 요청
  - 도와주기 버튼을 누르면 채팅방이 나타남
  - 채팅을 보내면 채팅방이 생성되고 도움이 진행됨
  - 버튼이 도움중 버튼으로 바뀜

- ### 도움중
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/37756abb-4cc0-431f-9f45-be3b6f3ed6f3" width="500" height="400">
  
  - 도와주고 있는 사람이 있으나 아직 완료되지 않은 타인의 요청

- ### 삭제하기
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/46864893-5d36-4460-b881-b60645f8d651" width="500" height="400">

  - 도와주고 있는 사람이 없는 본인의 요청
  - 삭제하기 버튼을 눌러 요청을 삭제할 수 있음

- ### 완료하기

  <img src="https://github.com/gkwls1012/madcamp_week3/assets/98662998/9b951e61-4f93-4e07-b286-0db63592f4f5" width="500" height="400">

  - 도와주고 있는 사람이 있는 본인의 요청
  - 완료하기 버튼을 눌러 요청을 완료할 수 있음
  - 요청을 완료하면 본인과 상대의 도움 기록이 업데이트 됨

## Tab3 : 채팅

> 본인이 상대의 도움 요청에 도와주기 버튼을 누르거나, 상대가 본인의 도움 요청에 도와주기 버튼을 눌러 채팅을 보내면 채팅방이 생성됩니다.
> 요청을 완료하지 않고 채팅방을 나가거나, 요청을 완료하며 채팅방을 나갈 수 있습니다.

<br />

- ### 채팅방 목록
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/26c77595-6a48-440d-a239-362b598ddecf" width = "200" height = "400">

  - 도움 요청의 이름과 마지막 메세지, 그리고 마지막 메세지가 전송된 시간을 확인할 수 있음
  - 터치하여 해당 채팅방 화면으로 넘어갈 수 있음

- ### 채팅방
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/4045e47f-a47a-455d-89ad-a492436533cf" width = "200" height = "400"><img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/d13e0e6e-e454-4ad5-bf54-6e3b3d875bbb" width = "200" height = "400"><img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/c8013c44-82f5-48d6-a8a8-4e4681565d51" width = "200" height = "400">

  - 자유롭게 채팅을 보낼 수 있음
  - 오른쪽 상단의 버튼을 누르면 두가지 화면을 볼 수 있음
  - 상대가 요청한 도움일 경우 채팅방 나가기 버튼만 있음
  - 본인이 요청한 도움일 경우 채팅방 나가기 버튼과 완료하기 버튼이 모두 있음
  - 채팅방 나가기 버튼을 누르면 도움 요청이 완료되지 않은 채 채팅방이 사라지고 도움이 중단됨
  - 완료하기 버튼을 누르면 도움 요청이 완료되며 채팅방이 사라짐

## Tab4 : 프로필
> 프로필 Tab에선 회원가입시 입력한 정보들을 확인할 수 있습니다.
> 프로필 편집과 로그아웃이 가능합니다.
> 도움 기록 정보를 확인할 수 있습니다.

- ### 프로필 편집
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/5c569ae7-4371-4725-81db-9f78a63e3443" width = "200" height = "400" >
  
  - 프로필 편집 버튼을 눌러 회원가입시 입력한 정보들을 수정할 수 있음

- ### 도움 기록
  <img src = "https://github.com/gkwls1012/madcamp_week3/assets/98662998/9d052db9-4424-4c34-9675-ca70de61633a" width = "200" height = "400" >
  
  - 내가 준 도움 기록 버튼과 내가 받은 도움 기록 버튼을 눌러 각각의 목록들을 확인할 수 있음
  - 도움 요청의 이름과 도움 요청이 완료된 날짜를 확인할 수 있음