# --- minimal prompt: (branch)dir, sorin-style ❯❯❯ ---

__c_teal='\[\e[0;36m\]'
__c_red_b='\[\e[1;31m\]'
__c_yellow_b='\[\e[1;33m\]'
__c_green_b='\[\e[1;32m\]'
__c_reset='\[\e[0m\]'

__set_prompt() {
  local last=$?
  local left=
  local branch

  # ----- (branch) as a green prefix when in a git repo -----
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    left="${__c_green_b}($branch) ${__c_reset}"
  fi

  # ----- arrows -----
  local arrows="${__c_red_b}❯${__c_yellow_b}❯${__c_green_b}❯"
  (( last != 0 )) && arrows="${__c_red_b}❯❯❯${__c_reset}"

  PS1="${left}${__c_teal}\W${__c_reset} ${arrows}${__c_reset} "
}

# run before every prompt so $? still holds the last command's exit status
PROMPT_COMMAND='__set_prompt'
