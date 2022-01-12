//go:build mage
// +build mage

package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/magefile/mage/mg"
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

func InstallDeps() error {
	fmt.Println("Installing Deps...")
	installs := []string{
		"github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0",
	}

	for _, pkg := range installs {
		fmt.Printf("Installing %s", pkg)
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
