# 쉘 관련 모음집...

## pre-install..

- rundevel
  - [repo](https://gitlab.com/newrovp/develconfig/-/tree/for_mac)
  - 대부분은 여기서 설치됨
  - 각 환경별 브랜치 잘 선택
- jira
  - [jira-cli](https://github.com/ankitpokhrel/jira-cli)
  - [jira-api-token](https://id.atlassian.com/manage-profile/security/api-tokens)
- zsh plugins
  - [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
  - [forgit](https://github.com/wfxr/forgit)

## jira.sh

> jira-cli 이용

- JIRA_API_TOKEN 을 export 한다.

### 명령어

- jiral(jl)
  - 프로젝트, 에픽명으로 일감 목록 보기
- jirap
  - 프로젝트 목록 보기
- jirad
  - 일감 제목으로 디테일 보기

## git.sh, aliases.sh

> 깃 관련. 대부분 forgit. fzf 를 이용해 선택

### 명령어

#### fzf selector...

- ga
  - git add
- glo
  - git log
- gd
  - git diff
- gcf
  - git checkout `file`
- gcb
  - git checkout `branch`
- gco
  - git checkout `commit`
- gss
  - git stash list

#### aliases

- gs
  - git status
- gsu
  - git stasu -u
- gsp
  - git stash pop
- gcm
  - git checkout master
- gpm
  - git pull origin master

#### 커스텀

> jira-cli 이용하기 싫으면 맨 아래 주석 부분 수정해서 사용하면됨

- create-branch
  - 지라 일감을 기준으로 브랜치 생성. jira-cli 가 필요함
- delete-branches
  - 브랜치 삭제. `tab` 을 이용해서 다중선택 가능
- fss
  - git stash 를 fzf 으로 사용.
  - cmd 를 중간에 선택할 수 있게 구현
