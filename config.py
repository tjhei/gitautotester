import os
import re

# github access token to set commit status
# fill in here or create token.txt with it
token  = ""
if os.path.isfile('token.txt'):
    token = open('token.txt').read().replace("\n","")

# directory where the aspect git repo sits
repodir = os.getcwd()+"/aspect"

# name of the user/organization on github
github_user = "geodynamics"

# name of the repo on github
github_repo = "aspect"

# github status context (""=disabled)
github_context = "astyle-tester"

# number of tests to go back in time when doing "run-all" default 10
n_old_tests = 10

# if a user that is_allowed() posts a comment that has
# has_hotword(text) return True, the PR is tested
def has_hotword(text):
    if "/run-tests" in text:
        return True
    return False

# return true if user is trusted
def is_allowed(username):
    return True

# make a nice link for a test result:
def make_link(sha):
    return "http://www.math.clemson.edu/~heister/aspect-astyler-logs/{}/".format(sha)


# for a given line l of the test output return
# "good", "bad", or "neutral"
def status_of_output_line(l):
    status = "neutral"
    if re.match(r'^OK$', l):
        status = "good"
    elif re.match(r'^FAIL', l):
        status = "bad"
    return status
