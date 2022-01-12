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

package cmd

import (
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

var stopCmd = &cobra.Command{
	Use:   "stop",
	Short: "Stop kubernetes",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		logrus.Traceln("trace stopping")
		logrus.Debugln("debug stopping")
		logrus.Printf("stopping")
	},
}

func init() {
	rootCmd.AddCommand(stopCmd)
}
