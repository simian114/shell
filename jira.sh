# JIRA CLI
export JIRA_API_TOKEN=$(gopass jira/pins/simian114@stunning.kr/api_token)
export JIRA_AUTH_TYPE=bearer

function jirap() {
  jira project list | cat
}

function jiral() {
  local project=$1
  if [ -z "$project" ]; then read project"?project> "; fi
  local epic=$2
  if [ -z "$epic" ]; then read epic"?epic> "; fi
  jira issue list -p$project -q'"Epic Link"='"$epic"' AND (status="In Progress" OR status="TO DO" OR status="task group")' --order-by status
}
alias jl='jiral'

function jirad() {
  local issue=$1
  if [ -z "$issue" ]; then read issue"?issue> "; fi
  jira issue view $issue
}
