import React from "react";


const ResultPage = (props) => {
    const data = props.location.state.response
    console.log("Here is the prop!")
    console.log(data)

    //We need to scan through all the keys in the data... 
    for (var key of Object.keys(data)) {
        console.log(key + " -> " + data[key])
        data[key].forEach(function (item, index) {
            for (var key2 of Object.keys(item)) {
                console.log(key2 + " -> " + item[key2])
                item[key2].forEach(function (item2, index2) {
                    console.log(item2)
                })
            }
        })
    }

    const deconstructData = (molecule1, interactions1) => {
        return (
            interactions1.map((value) => {
                return (
                    Object.entries(value).map(([molecule2, interactions2]) => {
                        return (
                            <h6>
                                {molecule1} --> {interactions2} {molecule2}
                            </h6>
                        )
                    })  
                )
            })
        )
    }

    return (
        <div>
            <header>
                <h3>
                    {Object.entries(data).map(([molecule1, interactions1]) => {
                        return (
                            deconstructData(molecule1, interactions1)
                        )
                    })}
                </h3>
            </header>
        </div>
    )
};

export default ResultPage;