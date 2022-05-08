function delete-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    #fzf --multi --preview="git log {} --"|
    # fzf-tmux -p80%,80% --multi --preview="git log {} --" --height=40% |
    fzf --multi --preview="git log {} --" --height=40% |
    xargs git branch --delete --force
}
alias gbd="delete-branches"

fss() {
  local cmd opts
  cmd="echo {} |cut -d: -f1 |xargs -I% git stash show --color=always --ext-diff % |$forgit_diff_pager"
  opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m -0 --tiebreak=index
        --preview=\"$cmd\"
        $FORGIT_STASH_FZF_OPTS
    "
  index=$(git stash list |
    FZF_DEFAULT_OPTS="$opts" fzf |
    cat | awk '{print $1}' |
    sed 's/stash@{//g' | sed 's/}://g')
  local num
  echo "명령어 선택"
  echo "${CYAN}[0] show"
  echo "${CYAN}[1] drop"
  echo "${CYAN}[2] pop"
  echo "${CYAN}[3] apply"
  read num"?> "
  if [ $num = 0 ]; then
    cmd="show"
  elif [ $num = 1 ]; then
    cmd="drop"
  elif [ $num = 2 ]; then
    cmd="pop"
  elif [ $num = 3 ]; then
    cmd="apply"
  else
    echo "invalid input"
    return
  fi
  git stash ${cmd} ${index}
}

function create-branch() {
  local project=$1
  local epic=$2
  {
    if [ -z $project ]; then
      jira project list
    else
      echo $project
    fi
  } >p0 &
  p0_pid=$!
  wait $p0_pid >/dev/null
  if [ -z $project ]; then
    project=$(cat p0 | fzf --height=30% --no-preview | awk '{print $1}')
  fi
  rm p0
  if [ -z $project ]; then
    return
  fi
  {
    if [ -z $epic ]; then
      jira epic list -s~Done -p$project --table --plain
    else
      echo $epic
    fi
  } >p1 &
  p1_pid=$!
  wait $p1_pid
  if [ -z $epic ]; then
    epic=$(cat p1 | fzf --height=70% --no-preview | awk '{print $2}')
  fi
  rm p1
  if [ -z $epic ]; then
    return
  fi

  { jira issue list -p$project -s~Done -q'"Epic Link"='"$epic"'' --order-by status --plain; } >p2 &
  p2_pid=$!
  wait $p2_pid
  branch_name=$(
    cat p2 |
      fzf --height=70% --no-preview |
      awk '{print $2}'
  )
  rm p2
  if [ -n "$branch_name" ]; then
    git checkout -b "$branch_name"
  fi
}

# function create-branch() {
#   local project=$1
#   if [ -z "$project" ]; then read project"?> "; fi
#   local jq_template query username password branch_name

#   jq_template='"' \
#     '\(.key). \(.fields.summary)' \
#     '\t' \
#     'Reporter: \(.fields.reporter.displayName)\n' \
#     'Created: \(.fields.created)\n' \
#     'Updated: \(.fields.updated)\n\n' \
#     '\(.fields.description)' \
#     '"'
#   query='project='"$project"' AND (status="In Progress" OR status="TO DO")'

#   branch_name=$(
#     curl \
#       --data-urlencode "jql=$query" \
#       --get \
#       --user "simian114@stunning.kr:$JIRA_API_TOKEN" \
#       --silent \
#       --compressed \
#       'https://stunning.atlassian.net/rest/api/2/search' |
#       jq ".issues[] | $jq_template" |
#       sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
#       fzf \
#         --with-nth=1 \
#         --delimiter='\t' \
#         --preview='echo -e {2}' \
#         --preview-window=top:wrap |
#       cut -f1 -d "."
#     # sed -e 's/\. /\t/' -e 's/[^a-zA-Z0-9\t]/-/g' |
#     # awk '{printf "%s/%s", $1, tolower($2)}'
#   )

#   echo $branch_name

#   # if [ -n "$branch_name" ]; then
#   #   git checkout -b "$branch_name"
#   # fi
# }
