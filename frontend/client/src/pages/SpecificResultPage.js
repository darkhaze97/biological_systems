import React from "react";


const SpecificResultPage = (props) => {
    const data = props.location.state.response
    console.log(data)

    const handleMolecule1 = () => {
        const molecule1 = data.molecule1
        return (
            <div>
                <h1>
                    {molecule1.name} ({molecule1.type})
                </h1>
                {Object.entries(molecule1).map(([infoColumn, info]) => {
                    return (
                        <div>
                            {infoColumn !== "name" && infoColumn !== "type" && 
                            (<h2>{infoColumn}: {info}</h2>)}
                        </div>
                    )
                })}
            </div>
        )
    }

    const handleMolecule2 = () => {
        const molecule2 = data.molecule2
        return (
            <div>
                <h1>
                    {molecule2.name} ({molecule2.type})
                </h1>
                {Object.entries(molecule2).map(([infoColumn, info]) => {
                    return (
                        <div>
                            {infoColumn !== "name" && infoColumn !== "type" && 
                            (<h2>{infoColumn}: {info}</h2>)}
                        </div>
                    )
                })}
            </div>
        )
    }

    const handleInteractions = () => {
        const interactions = data.interactions
        //Interactions looks something like:
        //{'Coding': {'name': 'Blah', 'info': {'info1': 'blah', 'info2': 'blah'}}}

        //The ternary operator is required below so that we can account for printing
        //either the 'name' or the 'info' values, which can be a string or an object.
        return (
            <div>
                <h1 class="test">
                    INTERACTIONS:
                </h1>
                {Object.entries(interactions).map(([infoColumn, info]) => {
                    return (
                        <div>
                            <h2>
                                Category: {infoColumn}
                            </h2>
                            {Object.entries(info).map(([attr, attrInfo]) => {
                                return(
                                    <div>
                                        {typeof attrInfo !== "object" ? 
                                            (
                                                <h2>
                                                    {attr}: {attrInfo}
                                                </h2>
                                            ) : (
                                                <div>
                                                    {Object.entries(attrInfo).map(([attr2, attr2Info]) => {
                                                        return (
                                                            <h2>
                                                                {attr2}: {attr2Info}
                                                            </h2>
                                                        )
                                                    })}
                                                </div>
                                            )
                                        }
                                    </div>
                                )
                            })}
                        </div>
                    )
                })}
            </div>
        )
    }

    return (
        <div>
            <p>
                {handleMolecule1()}
            </p>
            <p>
                {handleMolecule2()}
            </p>
            <p>
                {handleInteractions()}
            </p>
        </div>
    )
};

export default SpecificResultPage;