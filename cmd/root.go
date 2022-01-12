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
	"fmt"
	"io/ioutil"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	easy "github.com/t-tomalak/logrus-easy-formatter"
)

var (
	cfgFile  string
	debugVar bool
	traceVar bool
	quietVar bool
)

var rootCmd = &cobra.Command{
	Use:   "winkube",
	Short: "Run kubernetes on Windows",
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.winkube.yaml)")
	rootCmd.PersistentFlags().BoolVarP(&debugVar, "debug", "d", false, "Turn on debug verbosity")
	rootCmd.PersistentFlags().BoolVarP(&traceVar, "trace", "t", false, "Turn on trace verbosity")
	rootCmd.PersistentFlags().BoolVarP(&quietVar, "quiet", "q", false, "Turn off all output.")
}

func initConfig() {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)
		viper.AddConfigPath(".")
		viper.AddConfigPath(home)
		viper.SetConfigType("yaml")
		viper.SetConfigName(".winkube")
	}

	if debugVar || traceVar {
		if debugVar {
			logrus.SetLevel(logrus.DebugLevel)
		}
		if traceVar {
			logrus.SetLevel(logrus.TraceLevel)
		}
	} else {
		// run logrus as fmt.Println()
		logrus.SetFormatter(&easy.Formatter{
			LogFormat: "%msg%",
		})
	}

	if quietVar {
		logrus.SetOutput(ioutil.Discard)
	}

	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err == nil {
		fmt.Fprintln(os.Stderr, "Using config file:", viper.ConfigFileUsed())
	}
}
