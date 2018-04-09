# Copyright (C) 2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.PHONY: patch
patch: unpatch
	$(hide)                                                               \
	for patch_dir in $(BOARD_PATCH_DIRS); do                              \
	  for patch in $$(find $${patch_dir} -type f -name "*.patch"); do     \
	    echo "Applying patch $${patch}...";                               \
	    patch -p1 --reject-file=- --batch --no-backup-if-mismatch         \
	              --forward < $${patch} || {                              \
	      rc=$$?;                                                         \
	      echo "Patch $${patch} failed with code $${rc}, exiting...";     \
	      exit $${rc};                                                    \
	    };                                                                \
	  done;                                                               \
	done;

.PHONY: unpatch
unpatch:
	$(hide)                                                               \
	git_repos="";                                                         \
	for patch_dir in $(BOARD_PATCH_DIRS); do                              \
	  for patch in $$(find $${patch_dir} -type f -name "*.patch"); do     \
	    touched_files="$$(lsdiff --strip 1 $${patch})";                   \
	    for file in $${touched_files}; do                                 \
	      dir="$$(dirname $${file})";                                     \
	      repo_dir="$$(cd $${dir} && git rev-parse --show-toplevel)";     \
	      git_repos="$${git_repos}:$${repo_dir}";                         \
	    done;                                                             \
	  done;                                                               \
	done;                                                                 \
	git_repos="$$(echo $${git_repos} | tr ':' '\n' | sort -u)";           \
	for git_repo in $${git_repos}; do                                     \
	  echo "Cleaning git repo $${git_repo}...";                           \
	  (cd $${git_repo} && git checkout -f && git clean -fd);              \
	done;


