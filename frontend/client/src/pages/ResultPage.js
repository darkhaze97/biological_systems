import React from "react";
import axios from "axios";
import { Button } from "@material-ui/core"

const ResultPage = (props) => {
    const data = props.location.state.response
    console.log("Here is the prop!")
    console.log(data)

    data.forEach(function (item, index) {
        for (var key of Object.keys(item)) {
            console.log(key + " -> " + item[key])
            for (var key2 of Object.keys(item[key])) {
                console.log(key2 + " -> " + item[key][key2])
                item[key][key2].forEach(function (item2, index2) {
                    console.log(item2)
                })
            }
        }
    })

    const handleSubmit = (event, molecule1Info, molecule2Info) => {
        event.preventDefault()
        var molecule1InfoArray = molecule1Info.split("/")
        const molecule1 = molecule1InfoArray[0]
        const type1 = molecule1InfoArray[1]

        var molecule2InfoArray = molecule2Info.split("/")
        const molecule2 = molecule2InfoArray[0]
        const type2 = molecule2InfoArray[1]

        const values = {
            molecule1: molecule1,
            type1: type1,
            molecule2: molecule2,
            type2: type2
        }

        axios.post("http://127.0.0.1:8080/interactions/results/specific", {...values})
            .then((response) => {
                console.log(response)
                props.history.push('/interactions/results/specific', {response: response.data})
            })
            .catch((err) => {})
    }

    const deconstructData = () => {
        
        console.log("Hi")
        return (
            data.map(function (item, index) {
                return(
                    Object.entries(item).map(([molecule1, molecule2]) => {
                        return (
                            <div>
                                {molecule1}
                            </div>
                        )
                    })
                )
            })

         /*   data.forEach(function (item, index) {
                return(
                <div>
                    Hi
                </div> 
                )
            }*/
        )
            /*interactions1.map((value) => {
                return (
                    Object.entries(value).map(([molecule2, interactions2]) => {
                        return (
                            <div key={molecule1, molecule2}>
                                <Button onClick={(e) => {handleSubmit(e, molecule1, molecule2)}} type="submit" variant="contained" color="primary">
                                    {molecule1} --{'>'} {interactions2} {molecule2}
                                </Button>
                            </div>

                        )
                    })  
                )
            }) */
    }

    return (
        <div class="App">
            <header>
                <h3>
                   {deconstructData()}
                </h3>
            </header>
        </div>
    )
};

export default ResultPage;