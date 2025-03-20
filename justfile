changelog:
    npx auto-changelog --hide-credit -u -l 100 -b 100

format:
    just --unstable --fmt 
    npx prettier --write --cache . 
    mdsf format --cache . 
    gleam format 

lint:
    gleam fix 
    gleam check 

test:
    gleam test 

precommit:
    just changelog 
    just lint 
    just format
    gleam test 
