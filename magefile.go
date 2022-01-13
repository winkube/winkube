//go:build mage
// +build mage

/*
Copyright 2022 winkube and Contributors.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/magefile/mage/mg"
	"github.com/winkube/winkube/cmd"
)

func Build() error {
	mg.Deps(InstallDeps)
	fmt.Println("Building...")
	cmd := exec.Command("go", "build", "-o", "winkube.exe", ".")
	return cmd.Run()
}

func Ci() error {
	mg.Deps(InstallDeps)
	mg.Deps(Lint)
	mg.Deps(Test)
	mg.Deps(Build)
	mg.Deps(Docs)
	// mg.Deps(ValidateDocs)
	return nil
}

func Test() error {
	mg.Deps(InstallDeps)
	fmt.Println("Testing...")
	cmd := exec.Command("go", "test", "-coverprofile=coverage.txt", "-v", "./...")
	return cmd.Run()
}

func Lint() error {
	mg.Deps(InstallDeps)
	fmt.Println("Linting...")
	cmd := exec.Command("golangci-lint", "run", "-v", ".")
	return cmd.Run()
}

func Install() error {
	mg.Deps(Build)
	fmt.Println("Installing...")
	return os.Rename("./winkube.exe", "~/bin/winkube.exe")
}

func Docs() error {
	fmt.Println("Generating Docs...")
	if err := cmd.Docs("./docs/cmd/"); err != nil {
		return err
	}

	return nil
}

// doesn't work yet, crlf and other garbagbe is making this not do what i want
func ValidateDocs() error {
	fmt.Println("Validating Docs...")
	cmd := exec.Command("git", "status", "--porcelain", "--untracked-files=no")
	out, err := cmd.Output()
	if err != nil {
		return err
	}

	if string(out) != "" {
		return fmt.Errorf("Found changes while generating docs, please commit docs changes and try again")
	}

	return nil
}

func InstallDeps() error {
	fmt.Println("Installing Deps...")
	installs := []string{
		"github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0",
		"github.com/goreleaser/goreleaser@v1.2.5",
	}

	for _, pkg := range installs {
		fmt.Printf("Installing %s\n", pkg)
		cmd := exec.Command("go", "install", pkg)
		if err := cmd.Run(); err != nil {
			return err
		}
	}

	return nil
}

func Clean() error {
	fmt.Println("Cleaning...")
	rmFiles := []string{
		"./winkube.exe",
		"./coverage.txt",
	}
	for _, f := range rmFiles {
		if err := os.Remove(f); err != nil {
			if !strings.Contains(err.Error(), "The system cannot find the file specified") {
				return err
			}
		}
	}

	return nil
}
